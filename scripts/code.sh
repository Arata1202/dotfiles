#!/bin/bash
set -eu
repo=$(cd "$(dirname "$0")/.." && pwd -P)
while IFS= read -r extension || [[ -n "$extension" ]]; do
    [[ -z "$extension" ]] || code --install-extension "$extension"
done < "$repo/vscode/extensions"
