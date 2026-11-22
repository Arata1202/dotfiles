"""Save the package and extension lists as one snapshot."""

import fcntl
import os
import shutil
import signal
import sys
from contextlib import ExitStack, contextmanager
from pathlib import Path
from tempfile import TemporaryDirectory


@contextmanager
def defer_interrupt():
    previous = signal.pthread_sigmask(signal.SIG_BLOCK, {signal.SIGINT})
    try:
        yield
    finally:
        signal.pthread_sigmask(signal.SIG_SETMASK, previous)


def save(snapshot):
    targets = (Path("homebrew/.Brewfile").resolve(), Path("vscode/extensions").resolve())
    directory = os.open(".", os.O_RDONLY)
    try:
        fcntl.flock(directory, fcntl.LOCK_EX)
        with ExitStack() as cleanup:
            replacements = []
            for source, target in zip(("Brewfile", "extensions"), targets):
                if target.exists() and (not target.is_file() or not os.access(target, os.W_OK)):
                    raise OSError(f"Cannot update {target}")

                work = Path(cleanup.enter_context(TemporaryDirectory(dir=target.parent)))
                new = work / "new"
                shutil.copyfile(snapshot / source, new)
                backup = None
                if target.exists():
                    shutil.copymode(target, new)
                    backup = work / "original"
                    os.link(target, backup)
                replacements.append((new, target, backup))

            installed = []
            try:
                for new, target, backup in replacements:
                    with defer_interrupt():
                        os.replace(new, target)
                        installed.append((target, backup))
            except (OSError, KeyboardInterrupt):
                with defer_interrupt():
                    for target, backup in reversed(installed):
                        if backup is None:
                            target.unlink()
                        else:
                            os.replace(backup, target)
                raise
    finally:
        os.close(directory)


if __name__ == "__main__":
    try:
        save(Path(sys.argv[1]))
    except OSError as error:
        sys.exit(str(error))
