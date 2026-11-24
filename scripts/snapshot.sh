#!/bin/bash
set -eu
CDPATH= cd -- "$(dirname "$0")/.."
if [[ ${1:-} == --apply ]]; then
    snapshot=$(mktemp -d .snapshot.XXXXXXXX)
else
    snapshot=$(mktemp -d)
fi
trap 'rm -rf "$snapshot"' EXIT
brew bundle dump --file="$snapshot/brew-dump" --formula --cask --no-describe
# PHP and Composer come from mise. PHP builds use Homebrew OpenSSL 3.
awk '!/^brew "(php(@[0-9.]+)?|composer|(rbenv\/tap\/)?openssl@1[.]1)"(,|$)/' "$snapshot/brew-dump" > "$snapshot/Brewfile"
python3 scripts/list-extensions.py > "$snapshot/extensions"
if [[ ${1:-} == --apply ]]; then
    python3 scripts/apply-snapshot.py "$snapshot"
else
    preview() {
        local original="$1"
        [[ -e "$original" ]] || original=/dev/null
        diff -u -L "$1" -L "$1 (installed)" "$original" "$2" || [[ $? == 1 ]]
    }
    preview homebrew/.Brewfile "$snapshot/Brewfile"
    preview vscode/extensions "$snapshot/extensions"
fi
