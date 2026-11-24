#!/bin/bash
set -eu
repo=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd -P)
while IFS= read -r extension || [[ -n "$extension" ]]; do
    extension=${extension%$'\r'}
    [[ -z "$extension" ]] || code --install-extension "$extension"
done < "$repo/vscode/extensions"
