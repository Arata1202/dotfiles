import json
import os
import runpy
import shutil
import signal
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[1]
save = runpy.run_path(str(ROOT / "scripts/save-snapshot.py"))["save"]


class SnapshotTest(unittest.TestCase):
    def setUp(self):
        workspace = tempfile.TemporaryDirectory()
        self.addCleanup(workspace.cleanup)
        self.addCleanup(os.chdir, Path.cwd())
        os.chdir(workspace.name)
        self.brewfile = Path("homebrew/.Brewfile").resolve()
        self.extensions = Path("vscode/extensions").resolve()
        for target in (self.brewfile, self.extensions):
            target.parent.mkdir()
            target.write_text("original " + target.name)
        self.snapshot = Path("snapshot")
        self.snapshot.mkdir()
        (self.snapshot / "Brewfile").write_text("new packages")
        (self.snapshot / "extensions").write_text("test.parent\ntest.child\n")

    def assert_original_files(self):
        self.assertEqual(self.brewfile.read_text(), "original .Brewfile")
        self.assertEqual(self.extensions.read_text(), "original extensions")

    def test_second_write_failure_restores_first_file(self):
        replace = os.replace

        def fail_on_extensions(source, target):
            if target == self.extensions:
                self.assertEqual(self.brewfile.read_text(), "new packages")
                raise OSError("cannot replace extensions")
            replace(source, target)

        with patch("os.replace", fail_on_extensions):
            with self.assertRaisesRegex(OSError, "cannot replace extensions"):
                save(self.snapshot)
        self.assert_original_files()

    def test_ctrl_c_after_each_replace_restores_both_files(self):
        replace = os.replace
        for destination in (self.brewfile, self.extensions):
            with self.subTest(destination=destination.name):
                interrupted = False

                def interrupt_after_replace(source, target):
                    nonlocal interrupted
                    replace(source, target)
                    if target == destination and not interrupted:
                        interrupted = True
                        os.kill(os.getpid(), signal.SIGINT)

                with patch("os.replace", interrupt_after_replace):
                    with self.assertRaises(KeyboardInterrupt):
                        save(self.snapshot)
                self.assert_original_files()

    def test_snapshot_previews_until_explicitly_applied(self):
        shutil.copy(ROOT / "Makefile", ".")
        Path("scripts").mkdir()
        for name in ("update.sh", "save-snapshot.py", "list-extensions.py"):
            shutil.copy(ROOT / "scripts" / name, "scripts")
        commands = Path("bin").resolve()
        commands.mkdir()
        brew = commands / "brew"
        brew.write_text('#!/bin/sh\ncp snapshot/Brewfile "${3#--file=}"\n')
        code = commands / "code"
        manifest = Path("snapshot/test.parent")
        manifest.mkdir()
        (manifest / "package.json").write_text(json.dumps({
            "publisher": "test", "name": "parent", "extensionPack": ["test.child"],
        }))
        code.write_text(
            '#!/bin/sh\nif [ "$1" = --list-extensions ]; then cat snapshot/extensions; '
            'else echo snapshot/test.parent; fi\n'
        )
        for command in (brew, code):
            command.chmod(0o755)
        env = dict(os.environ, PATH=str(commands) + os.pathsep + os.environ["PATH"])
        for target in ("snapshot", "update"):
            preview = subprocess.check_output(["make", target], env=env, text=True)
            self.assertIn("+new packages", preview)
            self.assertIn("+test.parent", preview)
            self.assert_original_files()
        subprocess.run(["make", "snapshot-apply"], env=env, check=True)
        self.assertEqual(self.brewfile.read_text(), "new packages")
        self.assertEqual(self.extensions.read_text(), "test.parent\n")


if __name__ == "__main__":
    unittest.main()
