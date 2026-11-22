# .zprofile.local
[ -f ~/.zprofile.local ] && source ~/.zprofile.local

# homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# mise
eval "$(mise activate zsh)"

# direnv
eval "$(direnv hook zsh)"
