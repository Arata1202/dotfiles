echo ".Brewfileを更新します"
brew bundle dump --file=homebrew/.Brewfile --force

echo "extensionsを更新します"
code-insiders --list-extensions > vscode/extensions
