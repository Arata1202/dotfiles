echo "extensionsに記載されている拡張機能をインストールします"
cat $HOME/dotfiles/vscode/extensions | while read line
do
    code --install-extension $line
done
