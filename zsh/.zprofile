# .zprofile.local
[ -f ~/.zprofile.local ] && source ~/.zprofile.local

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise
eval "$(mise activate zsh)"
