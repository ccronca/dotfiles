#!/usr/bin/env bash
set -euo pipefail

DOTFILES_SYSTEMD="$HOME/dotfiles/systemd/user"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
LOCAL_BIN="$HOME/.local/bin"

echo "Setting up systemd user services..."

mkdir -p "$SYSTEMD_USER_DIR" "$LOCAL_BIN"

# Symlink every unit from the repo. Real files in ~/.config/systemd/user/
# (e.g. ai-rewriter.service) belong to someone else — skip, never clobber.
for unit in "$DOTFILES_SYSTEMD"/*.service "$DOTFILES_SYSTEMD"/*.timer; do
    [ -f "$unit" ] || continue
    name="$(basename "$unit")"
    target="$SYSTEMD_USER_DIR/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Warning: $SYSTEMD_USER_DIR/$name is a real file, skipping"
        continue
    fi
    if [ -L "$target" ]; then
        rm "$target"
    fi
    echo "Symlinking unit $name"
    ln -s "$unit" "$target"
done

# Helper scripts the units exec go on PATH.
for script in "$DOTFILES_SYSTEMD"/*.sh; do
    [ -f "$script" ] || continue
    name="$(basename "$script")"
    target="$LOCAL_BIN/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Warning: $LOCAL_BIN/$name is a real file, skipping"
        continue
    fi
    if [ -L "$target" ]; then
        rm "$target"
    fi
    echo "Symlinking script $name"
    ln -s "$script" "$target"
done

systemctl --user daemon-reload

for unit in "$DOTFILES_SYSTEMD"/*.service "$DOTFILES_SYSTEMD"/*.timer; do
    [ -f "$unit" ] || continue
    name="$(basename "$unit")"
    [ -e "$SYSTEMD_USER_DIR/$name" ] || continue
    # Services without an [Install] section are timer-triggered only —
    # enabling them directly would run them at every boot.
    if [ "${name##*.}" = service ] && ! grep -q '^\[Install\]' "$unit"; then
        continue
    fi
    echo "Enabling $name"
    systemctl --user enable --now "$name"
done

echo "systemd user services setup complete!"
