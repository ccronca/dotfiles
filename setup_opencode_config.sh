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

# commands/ is a real directory of per-file symlinks so commands from the
# private dotfiles repo (if installed) can live alongside the public ones.
COMMANDS_DIR="$OPENCODE_DIR/commands"
mkdir -p "$COMMANDS_DIR"

if [ -L "$COMMANDS_DIR" ]; then
    rm "$COMMANDS_DIR"
fi

for cmd_file in "$DOTFILES_OPENCODE/commands"/*.md "$DOTFILES_OPENCODE/commands"/.internal/*.md; do
    [ -f "$cmd_file" ] || continue
    name="$(basename "$cmd_file")"
    sub=""
    case "$cmd_file" in
        */.internal/*) sub=".internal/" ;;
    esac
    target="$COMMANDS_DIR/$sub$name"
    mkdir -p "$COMMANDS_DIR/$sub"
    [ -L "$target" ] && rm "$target"
    echo "Symlinking command $sub$name"
    ln -s "$cmd_file" "$target"
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
