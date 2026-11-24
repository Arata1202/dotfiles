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
        sudo /usr/bin/python3 -I -c '
import fcntl
import os
import sys

entry = os.fsencode(sys.argv[1])
with open("/etc/shells", "r+b") as shells:
    fcntl.flock(shells, fcntl.LOCK_EX)
    contents = shells.read()
    if entry not in contents.split(b"\n"):
        if contents and not contents.endswith(b"\n"):
            shells.write(b"\n")
        shells.write(entry + b"\n")
' "$ZSH_PATH"
        ;;
    *) exit "$status" ;;
esac

if [[ "$current_shell" == "UserShell: $ZSH_PATH" ]]; then
    exit 0
fi
chsh -s "$ZSH_PATH"

echo "Set brew-installed zsh as the default shell. Please restart your terminal."
