echo ".Brewfileを更新します"
brew bundle dump --file=~/dotfiles/homebrew/.Brewfile --force

echo "extensionsを更新します"
code --list-extensions > ~/dotfiles/vscode/extensions
