DOTFILES_DIR=$HOME/dotfiles

echo "シンボリックリンクを作成します"

for file in "$DOTFILES_DIR"/*/* "$DOTFILES_DIR"/*/.[^.]*; do

    if [[ $file == "$DOTFILES_DIR/." || $file == "$DOTFILES_DIR/.." ]]; then
        continue
    fi

    if [[ $file == "$DOTFILES_DIR/vscode/"* ]]; then
        target_dir="$HOME/Library/Application Support/Code/User"
        mkdir -p "$target_dir"
        link_name="$target_dir/$(basename "$file")"
    else
        link_name=$HOME/${file#"$DOTFILES_DIR"/*/}
    fi

    ln -sfn "$file" "$link_name"

    echo "リンクを作成: $file -> $link_name"
done

echo "シンボリックリンクがホームディレクトリ直下に作成されました"
