echo "Updating .Brewfile"
brew bundle dump --file=homebrew/.Brewfile --force --no-go

echo "Updating extensions"
code --list-extensions > vscode/extensions
