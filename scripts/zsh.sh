#!/bin/bash
set -eu

ZSH_PATH=$(brew --prefix)/bin/zsh
if [[ ! -x "$ZSH_PATH" ]]; then
    echo "Run make brew to install zsh first." >&2
    exit 1
fi

user_name=$(id -un)
current_shell=$(dscl . -read "/Users/$user_name" UserShell)
status=0
grep -Fxq "$ZSH_PATH" /etc/shells || status=$?
case $status in
    0) ;;
    1)
        last_byte=$(tail -c 1 /etc/shells)
        separator=
        if [[ -n "$last_byte" ]]; then separator=$'\n'; fi
        printf '%s%s\n' "$separator" "$ZSH_PATH" | sudo tee -a /etc/shells
        ;;
    *) exit "$status" ;;
esac

if [[ "$current_shell" == "UserShell: $ZSH_PATH" ]]; then
    exit 0
fi
chsh -s "$ZSH_PATH"

echo "Set brew-installed zsh as the default shell. Please restart your terminal."
