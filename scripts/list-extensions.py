"""List installed VS Code extensions that need an explicit install."""

import json
import subprocess
from pathlib import Path


def installed_roots():
    installed = subprocess.check_output(["code", "--list-extensions"], text=True).splitlines()
    if not installed:
        return []
    children = {name.lower(): set() for name in installed}
    command = ["code"]
    for name in installed:
        command.extend(["--locate-extension", name])
    locations = subprocess.check_output(command, text=True).splitlines()
    for location in locations:
        manifest = json.loads((Path(location) / "package.json").read_text())
        name = f"{manifest['publisher']}.{manifest['name']}".lower()
        if name in children:
            for field in ("extensionPack", "extensionDependencies"):
                children[name].update(dep.lower() for dep in manifest.get(field, []))
            children[name].intersection_update(children)

    bundled = set().union(*children.values())
    roots = []
    covered = set()
    for name in sorted(children, key=lambda name: (name in bundled, -len(children[name]), name)):
        if name in covered:
            continue
        roots.append(name)
        pending = [name]
        while pending:
            current = pending.pop()
            if current not in covered:
                covered.add(current)
                pending.extend(children[current])
    return sorted(roots)


if __name__ == "__main__":
    for extension in installed_roots():
        print(extension)
