#!/bin/bash
set -eu

repo=$(cd "$(dirname "$0")/.." && pwd -P)
code_user="$HOME/Library/Application Support/Code/User"

link_file() {
    local source="$repo/$1" target="$2"
    if [[ -L "$target" && "$target" -ef "$source" ]]; then
        return 0
    fi
    if [[ ! -f "$source" ]]; then
        echo "Missing source: $source" >&2
        return 1
    fi
    if [[ -e "$target" || -L "$target" ]]; then
        echo "Link conflict: $target (expected $source)" >&2
        return 1
    fi
    if [[ $phase == apply ]]; then
        mkdir -p "$(dirname "$target")"
        ln -s "$source" "$target"
    else
        local parent
        parent=$(dirname "$target")
        while [[ ! -d "$parent" ]]; do
            if [[ -e "$parent" || -L "$parent" ]]; then
                echo "Link conflict: $parent must be a directory (for $target)" >&2
                return 1
            fi
            parent=$(dirname "$parent")
        done
    fi
}

for phase in check apply; do
    link_file git/.gitconfig_shared "$HOME/.gitconfig_shared"
    link_file git/.gitignore_global "$HOME/.gitignore_global"
    link_file homebrew/.Brewfile "$HOME/.Brewfile"
    link_file mise/config.toml "$HOME/.config/mise/config.toml"
    link_file vim/.vimrc "$HOME/.vimrc"
    link_file vscode/settings.json "$code_user/settings.json"
    link_file vscode/keybindings.json "$code_user/keybindings.json"
    link_file zsh/.zprofile "$HOME/.zprofile"
    link_file zsh/.zshrc "$HOME/.zshrc"
    if [[ -f "$repo/local/.zprofile.local" ]]; then
        link_file local/.zprofile.local "$HOME/.zprofile.local"
    fi
done

if ! git config --global --path --get-all include.path | grep -Fxq "$HOME/.gitconfig_shared"; then
    git config --global --add include.path '~/.gitconfig_shared'
fi
