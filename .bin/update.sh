echo ".Brewfileを更新します"
cd homebrew
brew bundle dump --global --force

echo "extensionsを生成します"
cd ../vscode
code --list-extensions > extensions
