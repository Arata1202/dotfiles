DOTFILES_DIR=~/dotfiles

for file in "$DOTFILES_DIR"/*/.[^.]*; do
    [[ $file == "$DOTFILES_DIR/." || $file == "$DOTFILES_DIR/.." ]] && continue
    ln -sfn "$file" ~/${file#"$DOTFILES_DIR"/*/}
done
