#!/usr/bin/env bash
set -euo pipefail

DOTFILES_OPENCODE="$HOME/dotfiles/opencode"
OPENCODE_DIR="$HOME/.config/opencode"

CONFIG_FILES=(
    "opencode.jsonc"
    "dcp.jsonc"
    "AGENTS.md"
)

CONFIG_DIRS=(
    "agents"
    "commands"
    "plugins"
    "skills"
)

echo "Setting up opencode configuration symlinks..."

mkdir -p "$OPENCODE_DIR"

for file in "${CONFIG_FILES[@]}"; do
    SOURCE="$DOTFILES_OPENCODE/$file"
    TARGET="$OPENCODE_DIR/$file"

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

for dir in "${CONFIG_DIRS[@]}"; do
    SOURCE="$DOTFILES_OPENCODE/$dir"
    TARGET="$OPENCODE_DIR/$dir"

    if [ -d "$SOURCE" ]; then
        if [ -d "$TARGET" ] && [ ! -L "$TARGET" ]; then
            echo "Backing up existing $dir/ to $dir.backup/"
            mv "$TARGET" "$TARGET.backup"
        fi

        [ -L "$TARGET" ] && rm "$TARGET"

        echo "Symlinking $dir/"
        ln -s "$SOURCE" "$TARGET"
    else
        echo "Warning: $SOURCE not found, skipping"
    fi
done

echo ""
echo "opencode configuration setup complete!"
echo ""
echo "Symlinked files:"
find "$OPENCODE_DIR" -maxdepth 1 -type l -lname "*$DOTFILES_OPENCODE*" -ls
