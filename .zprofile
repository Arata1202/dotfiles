emulate sh
source ~/.profile
emulate zsh

# Orbstack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Code Insiders
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code-insiders --locate-shell-integration-path zsh)"

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
