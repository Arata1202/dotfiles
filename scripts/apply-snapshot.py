"""Publish the two generated manifests together, restoring the first on failure."""

import fcntl
import os
import sys
from pathlib import Path


def apply(snapshot):
    brewfile = Path("homebrew/.Brewfile")
    extensions = Path("vscode/extensions")
    # All applies in this checkout share the same directory inode and lock.
    directory = os.open(".", os.O_RDONLY)
    try:
        fcntl.flock(directory, fcntl.LOCK_EX)
        for target in (brewfile, extensions):
            if not os.access(target.parent, os.W_OK | os.X_OK) or target.is_symlink():
                raise OSError(f"Cannot update {target}")
            if target.exists() and not (target.is_file() and os.access(target, os.W_OK)):
                raise OSError(f"Cannot update {target}")

        original = snapshot / "original.Brewfile"
        if brewfile.exists():
            os.link(brewfile, original)
        os.replace(snapshot / "Brewfile", brewfile)
        try:
            os.replace(snapshot / "extensions", extensions)
        except OSError:
            if original.exists():
                os.replace(original, brewfile)
            else:
                brewfile.unlink()
            raise
    finally:
        os.close(directory)


if __name__ == "__main__":
    try:
        apply(Path(sys.argv[1]))
    except OSError as error:
        sys.exit(str(error))
