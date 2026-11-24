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
    pack_parents = {}
    for location in locate(installed):
        manifest = json.loads((Path(location) / "package.json").read_text())
        name = f"{manifest['publisher']}.{manifest['name']}".lower()
        if name in children:
            pack = set(member.lower() for member in manifest.get("extensionPack", []))
            missing = pack.difference(children)
            if pack and not any(manifest.get(key) for key in (
                "main", "browser", "contributes", "extensionDependencies",
            )):
                for member in pack:
                    pack_parents.setdefault(member, set()).add(name)
                # Built-in extensions are locatable but absent from --list-extensions.
                if missing and len(locate(sorted(missing))) < len(missing):
                    partial_packs.add(name)
            for field in ("extensionPack", "extensionDependencies"):
                children[name].update(dep.lower() for dep in manifest.get(field, []))
            children[name].intersection_update(children)

    pending = list(partial_packs)
    while pending:
        for parent in pack_parents.get(pending.pop(), ()):
            if parent not in partial_packs:
                partial_packs.add(parent)
                pending.append(parent)

    for name in partial_packs:
        del children[name]
    for members in children.values():
        members.difference_update(partial_packs)
    return explicit_roots(children)


def explicit_roots(children):
    roots = set()
    covered = set()
    for name in sorted(children):
        if name in covered:
            continue
        reachable = set()
        pending = [name]
        while pending:
            current = pending.pop()
            if current not in reachable:
                reachable.add(current)
                pending.extend(children[current])
        # A newly discovered parent supersedes any earlier root it installs,
        # including a representative reached through another member of a cycle.
        roots.difference_update(reachable)
        roots.add(name)
        covered.update(reachable)
    return sorted(roots)


if __name__ == "__main__":
    for extension in installed_roots():
        print(extension)
