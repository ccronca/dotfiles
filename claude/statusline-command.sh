#!/bin/bash
# Claude Code Statusline Script
# This script generates the statusline information displayed in Claude Code

# Get current git branch if in a git repository
if git rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)

    # Get repository status
    if [[ -n $(git status -s 2>/dev/null) ]]; then
        status="*" # Modified files
    else
        status=""
    fi

    # Count staged and unstaged changes
    staged=$(git diff --cached --numstat 2>/dev/null | wc -l)
    unstaged=$(git diff --numstat 2>/dev/null | wc -l)

    # Build status info
    changes=""
    if [[ $staged -gt 0 ]]; then
        changes="+$staged"
    fi
    if [[ $unstaged -gt 0 ]]; then
        if [[ -n $changes ]]; then
            changes="$changes ~$unstaged"
        else
            changes="~$unstaged"
        fi
    fi

    # Output the statusline
    if [[ -n $changes ]]; then
        echo "[$branch$status] $changes"
    else
        echo "[$branch]"
    fi
else
    # Not in a git repository
    echo "[$(basename "$PWD")]"
fi
