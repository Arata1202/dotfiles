#!/bin/bash
set -eu
cd "$(dirname "$0")/.."
snapshot=$(mktemp -d)
trap 'rm -rf "$snapshot"' EXIT
brew bundle dump --file="$snapshot/Brewfile" --no-go --no-vscode
code --list-extensions > "$snapshot/extensions"
python3 scripts/save-snapshot.py "$snapshot"
