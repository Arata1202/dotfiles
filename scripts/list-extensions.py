"""List installed VS Code extensions that need an explicit install."""

import json
import subprocess
from pathlib import Path


def locate(names):
    command = ["code"]
    for name in names:
        command.extend(["--locate-extension", name])
    return subprocess.check_output(command, text=True).splitlines()


def installed_roots():
    installed = subprocess.check_output(["code", "--list-extensions"], text=True).splitlines()
    if not installed:
        return []
    children = {name.lower(): set() for name in installed}
    partial_packs = set()
    for location in locate(installed):
        manifest = json.loads((Path(location) / "package.json").read_text())
        name = f"{manifest['publisher']}.{manifest['name']}".lower()
        if name in children:
            pack = set(member.lower() for member in manifest.get("extensionPack", []))
            missing = pack.difference(children)
            if missing and not any(manifest.get(key) for key in (
                "main", "browser", "contributes", "extensionDependencies",
            )):
                # Built-in extensions are locatable but absent from --list-extensions.
                if len(locate(sorted(missing))) < len(missing):
                    partial_packs.add(name)
            for field in ("extensionPack", "extensionDependencies"):
                children[name].update(dep.lower() for dep in manifest.get(field, []))
            children[name].intersection_update(children)

    for name in partial_packs:
        del children[name]
    for members in children.values():
        members.difference_update(partial_packs)
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
