#!/bin/bash
set -eu
if ! brew list zsh &>/dev/null; then
    echo "zsh is not installed. Starting installation..."
    brew install zsh
else
    echo "zsh is already installed."
fi

ZSH_PATH=$(brew --prefix)/bin/zsh

if ! grep -Fxq "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

if [[ "$(dscl . -read "/Users/$(id -un)" UserShell)" == "UserShell: $ZSH_PATH" ]]; then
    exit 0
fi
chsh -s "$ZSH_PATH"

echo "Set brew-installed zsh as the default shell. Please restart your terminal."
