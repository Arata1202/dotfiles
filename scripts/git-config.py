"""Load shared Git defaults before the user's global settings."""

from codecs import BOM_UTF8
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

shared = Path.home() / ".gitconfig_shared"
header = b'[include]\n\tpath = ~/.gitconfig_shared\n'


def check_path(config):
    for parent in config.parents:
        if os.path.lexists(parent) and not parent.is_dir():
            sys.exit(f"Git config conflict: {parent} must be a directory")
    if os.path.lexists(config) and not config.is_file():
        sys.exit(f"Git config conflict: {config} must be a regular file")


def update(config, first, check_only):
    if config == shared.resolve():
        return
    if not first and not config.exists():
        return

    if config.exists() and not os.access(config, os.W_OK):
        sys.exit(f"Git config is read-only: {config}")

    lock = config.with_name(config.name + ".lock")
    if check_only:
        if os.path.lexists(lock):
            sys.exit(f"Git config is locked: {lock}")
        return

    config.parent.mkdir(parents=True, exist_ok=True)
    try:
        fd = os.open(lock, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
        os.close(fd)
    except FileExistsError:
        sys.exit(f"Git config is locked: {lock}")
    replaced = False
    try:
        original = config.read_bytes() if config.exists() else b""
        bom = BOM_UTF8 if original.startswith(BOM_UTF8) else b""
        if config.exists():
            shutil.copy2(config, lock)
            body = original[len(bom):]
            if first and body.startswith(header):
                body = body[len(header):]
            if body != original:
                lock.write_bytes(body)

        # Remove the include written by earlier setups, preserving unrelated includes.
        for value in ("~/.gitconfig_shared", str(shared)):
            result = subprocess.run([
                "git", "config", "--file", str(lock), "--fixed-value",
                "--unset-all", "include.path", value,
            ])
            if result.returncode not in (0, 5):
                result.check_returncode()

        remaining = lock.read_bytes()
        updated = bom + (header if first else b"") + remaining
        if updated != original:
            lock.write_bytes(updated)
            os.replace(lock, config)
            replaced = True
    finally:
        if not replaced:
            lock.unlink(missing_ok=True)


def install_ignore(target):
    defaults = (Path(__file__).resolve().parents[1] / "git/.gitignore_global").read_bytes()
    original = target.read_bytes() if target.exists() else b""
    bom = BOM_UTF8 if original.startswith(BOM_UTF8) else b""
    body = original[len(bom):]
    existing = set(body.splitlines())
    missing = [rule for rule in defaults.splitlines() if rule not in existing]
    if not missing:
        return

    target.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=target.parent, delete=False) as output:
        temporary = Path(output.name)
    try:
        temporary.write_bytes(bom + b"\n".join(missing) + b"\n" + body)
        if target.exists():
            shutil.copystat(target, temporary)
        os.replace(temporary, target)
    finally:
        temporary.unlink(missing_ok=True)


if __name__ == "__main__":
    xdg = Path(os.environ.get("XDG_CONFIG_HOME") or Path.home() / ".config")
    ignore = xdg / "git/ignore"
    output = subprocess.check_output(["git", "var", "GIT_CONFIG_GLOBAL"])
    paths = [Path(os.fsdecode(line)) for line in output.split(b"\n") if line]
    check_only = sys.argv[1:] == ["--check"]
    if check_only:
        check_path(ignore)
        for path in paths:
            check_path(path)
    configs = dict.fromkeys(path.resolve() for path in paths)
    for index, config in enumerate(configs):
        update(config, first=index == 0, check_only=check_only)
    if not check_only:
        install_ignore(ignore.resolve())
