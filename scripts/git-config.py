"""Load shared Git defaults before the user's global settings."""

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


def update(config, first):
    if config == shared.resolve():
        return
    if not first and not config.exists():
        return

    config.parent.mkdir(parents=True, exist_ok=True)
    lock = config.with_name(config.name + ".lock")
    with lock.open("xb"):
        pass
    replaced = False
    try:
        original = config.read_bytes() if config.exists() else b""
        if config.exists():
            shutil.copy2(config, lock)
            if first and original.startswith(header):
                lock.write_bytes(original[len(header):])
        else:
            lock.chmod(0o600)

        # Remove the include written by earlier setups, preserving unrelated includes.
        for value in ("~/.gitconfig_shared", str(shared)):
            result = subprocess.run([
                "git", "config", "--file", str(lock), "--fixed-value",
                "--unset-all", "include.path", value,
            ])
            if result.returncode not in (0, 5):
                result.check_returncode()

        remaining = lock.read_bytes()
        updated = header + remaining if first else remaining
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
    existing = set(original.splitlines())
    missing = [rule for rule in defaults.splitlines() if rule not in existing]
    if not missing:
        return

    target.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=target.parent, delete=False) as output:
        temporary = Path(output.name)
    try:
        temporary.write_bytes(b"\n".join(missing) + b"\n" + original)
        if target.exists():
            shutil.copystat(target, temporary)
        os.replace(temporary, target)
    finally:
        temporary.unlink(missing_ok=True)


if __name__ == "__main__":
    xdg = Path(os.environ.get("XDG_CONFIG_HOME") or Path.home() / ".config")
    ignore = xdg / "git/ignore"
    paths = subprocess.check_output(["git", "var", "GIT_CONFIG_GLOBAL"], text=True)
    if sys.argv[1:] == ["--check"]:
        check_path(ignore)
        for path in paths.splitlines():
            check_path(Path(path))
        sys.exit(0)
    configs = dict.fromkeys(Path(path).resolve() for path in paths.splitlines())
    for index, config in enumerate(configs):
        update(config, first=index == 0)
    install_ignore(ignore.resolve())
