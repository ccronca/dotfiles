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
* Configure Gemini settings (symlinks config files)

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
* **Symlinked directories**: agents/, commands/, hooks/, plugins/
* **Local files preserved**: CLAUDE.local.md, history.jsonl, debug/, file-history/, session-env/

To manually update Claude configuration only:

```bash
./setup_claude_config.sh
```

## Gemini Configuration

The Gemini configuration is handled separately:

* **Symlinked files**: settings.json

To manually update Gemini configuration only:

```bash
./setup_gemini_config.sh
```

## MCP Server Configuration

The repository includes project-level MCP configuration in `.mcp.json` for Obsidian vault integration.

**Note:** Due to a bug in mcp-obsidian (see [PR #89](https://github.com/MarkusPfundstein/mcp-obsidian/pull/89)), only one vault can be configured at a time.

To use the MCP server:

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and add your Obsidian API key:
   ```bash
   OBSIDIAN_MYJOURNAL_API_KEY=your_actual_key
   ```

3. Source the environment variables before running Claude Code:
   ```bash
   source .env
   ```

The MCP server will be available when Claude Code is run from this directory.

## Google Calendar Integration

The repository includes a `/calendar-journal` command for generating meeting summaries from Google Calendar.

### Setup gcalcli

Install and configure gcalcli following the [official documentation](https://github.com/insanum/gcalcli).

The first run will prompt for OAuth authorization to access your Google Calendar.

### Using the Calendar Journal Command

Generate meeting summaries and save them to your Obsidian vault:

```bash
# Today's meetings
/calendar-journal

# This week's meetings
/calendar-journal week

# Specific date
/calendar-journal 2025-11-25
```

The command will:
- Fetch events from Google Calendar using gcalcli
- Analyze meeting patterns and time distribution
- Generate a summary with statistics and observations
- Save to `Journal/Calendar/YYYY-MM-DD.md` in Obsidian vault
- Add appropriate tags for searchability

## AI Prompt Rewriter Integration

The repository includes a prompt rewriting feature that improves your prompts for better clarity and grammar using the [ai-rewriter](https://github.com/ccronca/ai-rewriter) service.

### Setup ai-rewriter

1. Clone and set up the ai-rewriter service:
   ```bash
   git clone https://github.com/ccronca/ai-rewriter.git
   cd ai-rewriter
   # Follow the setup instructions in the repository
   ```

2. Start the ai-rewriter service (default port: 8787):
   ```bash
   # The service should be running on http://127.0.0.1:8787
   ```

### Using the Prompt Rewriter

Two ways to trigger prompt rewriting:

1. **Using `#rw` prefix** - Automatic hook-based rewriting:
   ```
   #rw how I can make this project better?
   ```

2. **Using `/rw` command** - Explicit slash command:
   ```
   /rw how I can make this project better?
   ```

Both methods will:
- Send your prompt to the ai-rewriter service
- Show you the original and improved versions
- Highlight key improvements (grammar, clarity, structure)
- Respond to the improved prompt

This feature helps you learn English by showing concrete examples of improvements.

## Manual Setup

If you prefer to set up components individually, you can run scripts separately or manually symlink specific files.
