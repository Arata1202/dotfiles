echo ".Brewfileを更新します"
brew bundle dump --file=$HOME/dotfiles/homebrew/.Brewfile --force

echo "extensionsを更新します"
code --list-extensions > $HOME/dotfiles/vscode/extensions
