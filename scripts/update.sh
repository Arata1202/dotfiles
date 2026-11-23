#!/bin/bash
set -eu
cd "$(dirname "$0")/.."
snapshot=$(mktemp -d)
trap 'rm -rf "$snapshot"' EXIT
brew bundle dump --file="$snapshot/brew-dump" --no-go --no-vscode --no-describe
# The mise PHP installation also provides Composer.
awk '!/^brew "(php|composer)"(,|$)/' "$snapshot/brew-dump" > "$snapshot/Brewfile"
python3 scripts/list-extensions.py > "$snapshot/extensions"
if [[ ${1:-} == --apply ]]; then
    python3 scripts/save-snapshot.py "$snapshot"
else
    preview() {
        local original="$1"
        [[ -e "$original" ]] || original=/dev/null
        diff -u -L "$1" -L "$1 (installed)" "$original" "$2" || [[ $? == 1 ]]
    }
    preview homebrew/.Brewfile "$snapshot/Brewfile"
    preview vscode/extensions "$snapshot/extensions"
fi
