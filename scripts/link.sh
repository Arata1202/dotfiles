#!/bin/bash
set -eu

repo=$(cd "$(dirname "$0")/.." && pwd -P)
zsh_dir=${ZDOTDIR:-$HOME}
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
    link_file homebrew/.Brewfile "$HOME/.Brewfile"
    link_file mise/config.toml "${XDG_CONFIG_HOME:-$HOME/.config}/mise/config.toml"
    link_file vim/.vimrc "$HOME/.vimrc"
    link_file vscode/settings.json "$code_user/settings.json"
    link_file zsh/.zprofile "$zsh_dir/.zprofile"
    link_file zsh/.zshrc "$zsh_dir/.zshrc"
    if [[ -f "$repo/local/.zprofile.local" ]]; then
        link_file local/.zprofile.local "$zsh_dir/.zprofile.local"
    fi
    if [[ $phase == check ]]; then
        python3 "$repo/scripts/git-config.py" --check
    fi
done

python3 "$repo/scripts/git-config.py"
