if ! brew list zsh &>/dev/null; then
    echo "zshがインストールされていないため、インストールを開始します..."
    brew install zsh
else
    echo "zshはすでにインストールされています。"
fi

ZSH_PATH=$(brew --prefix)/bin/zsh

if ! grep -Fxq "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

chsh -s "$ZSH_PATH"

echo "brewでインストールしたzshをデフォルトシェルに設定しました。ターミナルを再起動してください。"
