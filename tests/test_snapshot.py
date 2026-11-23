import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


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
        (self.snapshot / "Brewfile").write_text('new packages\nbrew "php"\nbrew "composer"\nbrew "rbenv/tap/openssl@1.1"\n')
        (self.snapshot / "extensions").write_text(
            "test.parent\ntest.child\ntest.dependency\ntest.partial\ntest.outer\ntest.standalone\n"
        )

    def assert_original_files(self):
        self.assertEqual(self.brewfile.read_text(), "original .Brewfile")
        self.assertEqual(self.extensions.read_text(), "original extensions")

    def test_snapshot_previews_until_explicitly_applied(self):
        shutil.copy(ROOT / "Makefile", ".")
        Path("scripts").mkdir()
        for name in ("snapshot.sh", "list-extensions.py"):
            shutil.copy(ROOT / "scripts" / name, "scripts")
        commands = Path("bin").resolve()
        commands.mkdir()
        brew = commands / "brew"
        brew.write_text("""#!/bin/sh
for arg do
    case "$arg" in
        --file=*) exec cp snapshot/Brewfile "${arg#--file=}" ;;
    esac
done
exit 1
""")
        code = commands / "code"
        manifest = Path("snapshot/test.parent")
        manifest.mkdir()
        (manifest / "package.json").write_text(json.dumps({
            "publisher": "test", "name": "parent", "extensionPack": ["test.child"],
        }))
        standalone = Path("snapshot/test.standalone")
        standalone.mkdir()
        (standalone / "package.json").write_text(json.dumps({
            "publisher": "test", "name": "standalone",
            "extensionDependencies": ["test.dependency"],
        }))
        partial = Path("snapshot/test.partial")
        partial.mkdir()
        (partial / "package.json").write_text(json.dumps({
            "publisher": "test", "name": "partial",
            "extensionPack": ["test.standalone", "test.removed"],
        }))
        outer = Path("snapshot/test.outer")
        outer.mkdir()
        (outer / "package.json").write_text(json.dumps({
            "publisher": "test", "name": "outer", "extensionPack": ["test.partial"],
        }))
        code.write_text("""#!/bin/sh
if [ "$1" = --list-extensions ]; then
    exec cat snapshot/extensions
fi
for name do
    if [ -d "snapshot/$name" ]; then echo "snapshot/$name"; fi
done
""")
        for command in (brew, code):
            command.chmod(0o755)
        env = dict(os.environ, PATH=str(commands) + os.pathsep + os.environ["PATH"])
        preview = subprocess.check_output(["make", "snapshot"], env=env, text=True)
        self.assertIn("+new packages", preview)
        self.assertIn("+test.parent", preview)
        self.assert_original_files()
        subprocess.run(["make", "snapshot-apply"], env=env, check=True)
        self.assertEqual(self.brewfile.read_text(), "new packages\n")
        self.assertEqual(self.extensions.read_text(), "test.parent\ntest.standalone\n")


if __name__ == "__main__":
    unittest.main()
