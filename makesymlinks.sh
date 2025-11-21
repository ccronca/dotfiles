#!/bin/bash

dir=~/dotfiles
olddir=~/dotfiles_old
files="vimrc tmux.conf gitignore zshrc aliases gitconfig bashrc bash_logout bash_profile ctags.d mcp.json"

echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

echo "Changing to the $dir directory"
cd $dir
echo "...done"

for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

DIRS=("$HOME/.vim/backups" "$HOME/.vim/swaps" "$HOME/.vim/undo")

for vim_dir in "${DIRS[@]}"; do
    mkdir -p "$vim_dir"
done

PLUGIN_DIR="$HOME/.vim/pack/plugins/start"

declare -A PLUGINS=(
    ["ctrlp.vim"]="https://github.com/ctrlpvim/ctrlp.vim.git"
    ["tagbar"]="https://github.com/preservim/tagbar.git"
)

mkdir -p "$PLUGIN_DIR"

echo "Managing Vim plugins in $PLUGIN_DIR..."

for plugin in "${!PLUGINS[@]}"; do
    PLUGIN_PATH="$PLUGIN_DIR/$plugin"

    if [ -d "$PLUGIN_PATH/.git" ]; then
        echo "Updating $plugin..."
        git -C "$PLUGIN_PATH" pull --ff-only
    else
        echo "Installing $plugin..."
        git clone --depth=1 "${PLUGINS[$plugin]}" "$PLUGIN_PATH"
    fi
done

echo "Vim plugins management complete!"

echo ""
echo "Setting up Claude configuration..."
bash "$dir/setup_claude_config.sh"
