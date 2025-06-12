echo "Updating .Brewfile"
brew bundle dump --file=homebrew/.Brewfile --force

echo "Updating extensions"
code --list-extensions > vscode/extensions
