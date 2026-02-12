echo "Installing extensions listed in extensions"
cat $HOME/dotfiles/vscode/extensions | while read line
do
    code --install-extension $line
done
