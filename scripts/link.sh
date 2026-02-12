DOTFILES_DIR=~/dotfiles

echo "Creating symbolic links"

for file in "$DOTFILES_DIR"/*/* "$DOTFILES_DIR"/*/.[^.]*; do

    if [[ $file == "$DOTFILES_DIR/." || $file == "$DOTFILES_DIR/.." ]]; then
        continue
    fi

    if [[ $file == "$DOTFILES_DIR/vscode/"* ]]; then
        target_dir="$HOME/Library/Application Support/Code/User"
        mkdir -p "$target_dir"
        link_name="$target_dir/$(basename "$file")"
    else
        link_name=~/${file#"$DOTFILES_DIR"/*/}
    fi

    ln -sfn "$file" "$link_name"

    echo "Created link: $file -> $link_name"
done

echo "Symbolic links have been created in the home directory"
