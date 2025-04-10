# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Git / Docker / Go
export PATH="/opt/homebrew/bin:$PATH"

# PHP
export PATH="/opt/homebrew/opt/php@8.1/bin:/opt/homebrew/opt/php@8.1/sbin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/php@8.1/lib"
export CPPFLAGS="-I/opt/homebrew/opt/php@8.1/include"

# Ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Flutter
export PATH="$HOME/flutter/bin:$PATH"

# Android
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"

# Orbstack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Code Insiders
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code-insiders --locate-shell-integration-path zsh)"
