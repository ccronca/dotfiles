#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$HOME/dotfiles/opencode"
TARGET_LINK="$HOME/.config/.opencode"
TARGET_PARENT_DIR="$HOME/.config"

echo "Setting up opencode configuration symlink..."
mkdir -p "$TARGET_PARENT_DIR"

# If the target exists and is not a symlink (i.e., it's a real directory), back it up
if [ -e "$TARGET_LINK" ] && [ ! -L "$TARGET_LINK" ]; then
    echo "Backing up existing $TARGET_LINK to $TARGET_LINK.backup"
    mv "$TARGET_LINK" "$TARGET_LINK.backup"
fi

# Remove the target if it is a symlink, to ensure we can create a new one
[ -L "$TARGET_LINK" ] && rm "$TARGET_LINK"

echo "Symlinking $SOURCE_DIR to $TARGET_LINK"
ln -s "$SOURCE_DIR" "$TARGET_LINK"

echo ""
echo "opencode configuration setup complete!"
echo ""
echo "Symlink created:"
ls -ld "$TARGET_LINK"
