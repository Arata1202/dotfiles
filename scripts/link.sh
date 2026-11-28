#!/bin/bash
set -eu

repo=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd -P)
code_user="$HOME/Library/Application Support/Code/User"

link_path() {
    local source="$repo/$1" target="$2"
    if [[ ${3:-file} == directory && ! -d "$source" || ${3:-file} == file && ! -f "$source" ]]; then
        echo "Missing source: $source" >&2
        return 1
    fi
    if [[ -L "$target" && "$target" -ef "$source" ]]; then
        return 0
    fi
    if [[ -e "$target" || -L "$target" ]]; then
        echo "Link conflict: $target (expected $source)" >&2
        return 1
    fi
    if [[ $phase == apply ]]; then
        mkdir -p "$(dirname "$target")"
        python3 -c 'import os, sys; os.symlink(sys.argv[1], sys.argv[2])' "$source" "$target"
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
        if [[ ! -w "$parent" || ! -x "$parent" ]]; then
            echo "Cannot create $target under $parent" >&2
            return 1
        fi
    fi
}

for phase in check apply; do
    for skill in ocr-review ocr-scan; do
        link_path "codex/skills/$skill" "${CODEX_HOME:-$HOME/.codex}/skills/$skill" directory
    done
    link_path git/.gitconfig_shared "$HOME/.gitconfig_shared"
    link_path homebrew/.Brewfile "$HOME/.Brewfile"
    link_path mise/config.toml "${XDG_CONFIG_HOME:-$HOME/.config}/mise/config.toml"
    link_path vim/.vimrc "$HOME/.vimrc"
    link_path vscode/settings.json "$code_user/settings.json"
    link_path zsh/.zprofile "$HOME/.zprofile"
    link_path zsh/.zshrc "$HOME/.zshrc"
    if [[ $phase == check ]]; then
        python3 "$repo/scripts/git-config.py" --check
    fi
done

python3 "$repo/scripts/git-config.py"
