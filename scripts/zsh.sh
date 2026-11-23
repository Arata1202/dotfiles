#!/bin/bash
set -eu

ZSH_PATH=$(brew --prefix)/bin/zsh
if [[ ! -x "$ZSH_PATH" ]]; then
    echo "Run make brew to install zsh first." >&2
    exit 1
fi

if ! grep -Fxq "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

if [[ "$(dscl . -read "/Users/$(id -un)" UserShell)" == "UserShell: $ZSH_PATH" ]]; then
    exit 0
fi
chsh -s "$ZSH_PATH"

echo "Set brew-installed zsh as the default shell. Please restart your terminal."
