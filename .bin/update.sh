echo ".Brewfileを更新します"
brew bundle dump --file=homebrew/.Brewfile --force

echo "extensionsを更新します"
code --list-extensions > vscode/extensions
