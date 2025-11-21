# Dotfiles

Personal configuration files for shell, vim, git, and development tools.

## Installation

Clone the repository to your home directory:

```bash
git clone https://github.com/ccronca/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Run the installation script:

```bash
./makesymlinks.sh
```

This script will:

* Back up existing dotfiles to `~/dotfiles_old/`
* Create symlinks from your home directory to the dotfiles repository
* Set up vim directories (backups, swaps, undo)
* Install and update vim plugins (CtrlP, Tagbar)
* Configure Claude Code settings (symlinks config files while preserving runtime data)

## What's Included

* **Shell configs**: bashrc, zshrc, aliases, bash_profile, bash_logout
* **Git**: gitconfig, gitignore
* **Vim**: vimrc, ctags configuration
* **Tmux**: tmux.conf
* **Claude Code**: Configuration files and custom commands
* **MCP Servers**: Project-level MCP configuration (.mcp.json) for Obsidian vaults

## Claude Code Configuration

The Claude configuration is handled separately to preserve your local runtime data:

* **Symlinked files**: CLAUDE.md, settings.json, statusline-command.sh, .gitignore
* **Symlinked directories**: agents/, commands/, plugins/
* **Local files preserved**: CLAUDE.local.md, history.jsonl, debug/, file-history/, session-env/

To manually update Claude configuration only:

```bash
./setup_claude_config.sh
```

## MCP Server Configuration

The repository includes project-level MCP configuration in `.mcp.json` for three Obsidian servers. To use them:

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and add your Obsidian API keys:
   ```bash
   OBSIDIAN_SECONDBRAIN_API_KEY=your_actual_key
   OBSIDIAN_MYJOURNAL_API_KEY=your_actual_key
   OBSIDIAN_ENGLISH_API_KEY=your_actual_key
   ```

3. Source the environment variables before running Claude Code:
   ```bash
   source .env
   ```

The MCP servers will be available when Claude Code is run from this directory.

## Manual Setup

If you prefer to set up components individually, you can run scripts separately or manually symlink specific files.
