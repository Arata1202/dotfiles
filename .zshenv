# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

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

# Flutter
export PATH="$HOME/flutter/bin:$PATH"

# Docker
export PATH="$HOME/.docker/bin:$PATH"

# Go
export PATH="$PATH:$(go env GOPATH)/bin"

# Android
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

export PATH="/usr/local/bin:$PATH"
