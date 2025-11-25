#!/bin/bash

DOTFILES_CLAUDE="$HOME/dotfiles/claude"
CLAUDE_DIR="$HOME/.claude"

CONFIG_FILES=(
    "CLAUDE.md"
    "settings.json"
    "statusline-command.sh"
    ".gitignore"
)

CONFIG_DIRS=(
    "agents"
    "commands"
    "hooks"
    "plugins"
)

echo "Setting up Claude configuration symlinks..."

mkdir -p "$CLAUDE_DIR"

for file in "${CONFIG_FILES[@]}"; do
    SOURCE="$DOTFILES_CLAUDE/$file"
    TARGET="$CLAUDE_DIR/$file"

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
    SOURCE="$DOTFILES_CLAUDE/$dir"
    TARGET="$CLAUDE_DIR/$dir"

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
echo "Claude configuration setup complete!"
echo ""
echo "Symlinked files:"
ls -la "$CLAUDE_DIR" | grep " -> $DOTFILES_CLAUDE"
