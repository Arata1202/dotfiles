#!/bin/bash
set -eu
echo "Installing packages listed in mise/config.toml"
repo=$(cd "$(dirname "$0")/.." && pwd -P)
cd "$HOME"
config="$HOME/.config/mise/config.toml"
if [[ ! "$config" -ef "$repo/mise/config.toml" ]]; then
    echo "Run make link before installing mise tools." >&2
    exit 1
fi
MISE_PARANOID=1 mise trust "$config"
mise install
