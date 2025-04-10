echo "セットアップを開始します"

# dotfilesのシンボリックリンクを作成する
source ~/dotfiles/.bin/link.sh

# homebrewがインストールされていない場合はインストール
if ! type brew >/dev/null 2>&1; then
  echo "Homebrewをインストールします"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrewはすでにインストールされています"
fi

# Brewfileに記載されているパッケージをインストール
source ~/dotfiles/.bin/brew.sh

# zshをbrewのものに置き換え
source ~/dotfiles/.bin/zsh.sh

echo "セットアップが完了しました"
echo "ターミナルを再起動してください。"