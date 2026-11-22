#!/bin/bash
set -eu
cd "$(dirname "$0")/.."
echo "Installing packages listed in .Brewfile"
brew bundle --file=homebrew/.Brewfile --verbose
