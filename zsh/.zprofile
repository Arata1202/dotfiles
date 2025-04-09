export PATH="/usr/local/bin:$PATH"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Docker
export PATH="$HOME/.docker/bin:$PATH"

# PHP
export PATH="/opt/homebrew/opt/php@8.0/bin:/opt/homebrew/opt/php@8.0/sbin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/php@8.0/lib"
export CPPFLAGS="-I/opt/homebrew/opt/php@8.0/include"

# Git
export PATH="/usr/local/opt/git/bin:$PATH"

# Ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"

# Go
export PATH="/usr/local/opt/go/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Flutter
export PATH="$HOME/flutter/bin:$PATH"

# Android
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# Orbstack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Code Insiders
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code-insiders --locate-shell-integration-path zsh)"
