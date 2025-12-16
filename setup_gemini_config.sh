#!/bin/bash

DOTFILES_GEMINI="$HOME/dotfiles/gemini"
GEMINI_DIR="$HOME/.gemini"

CONFIG_FILES=(
    "settings.json"
)

echo "Setting up Gemini configuration symlinks..."

mkdir -p "$GEMINI_DIR"

for file in "${CONFIG_FILES[@]}"; do
    SOURCE="$DOTFILES_GEMINI/$file"
    TARGET="$GEMINI_DIR/$file"

    if [ -e "$SOURCE" ]; then
        if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
            echo "Backing up existing $file to $file.backup"
            mv "$TARGET" "$TARGET.backup"
        fi

        [ -L "$TARGET" ] && rm "$TARGET"

        echo "Symlinking $file"
        ln -s "$SOURCE" "$TARGET"
    else
        echo "Warning: $SOURCE not found, skipping"
    fi
done

echo ""
echo "Gemini configuration setup complete!"
echo ""
echo "Symlinked files:"
find "$GEMINI_DIR" -maxdepth 1 -type l -lname "*$DOTFILES_GEMINI*" -ls
