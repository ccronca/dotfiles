#!/usr/bin/env python3
"""
Prompt Rewriter Hook for Claude Code
Rewrites user prompts using the local ai-rewriter service when prefixed with #rw
Shows both original and improved versions for learning

Requirements:
- ai-rewriter service running on http://127.0.0.1:8787
- Repository: https://github.com/ccronca/ai-rewriter
"""

import json
import sys
import urllib.request
import urllib.error
from typing import Any, Dict


def call_rewriter_service(text: str, mode: str = "claude-prompt") -> str:
    """Call the ai-rewriter service to improve the prompt."""
    url = "http://127.0.0.1:8787/rewrite"
    data = json.dumps({"text": text, "mode": mode}).encode('utf-8')
    headers = {'Content-Type': 'application/json'}

    req = urllib.request.Request(url, data=data, headers=headers)

    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            result = json.loads(response.read().decode('utf-8'))
            return result.get('result', text)
    except urllib.error.URLError as e:
        print(f"Error connecting to ai-rewriter service: {e}", file=sys.stderr)
        return text
    except Exception as e:
        print(f"Error calling ai-rewriter: {e}", file=sys.stderr)
        return text


def should_rewrite(message: str) -> bool:
    """Check if message should be rewritten (starts with #rw)."""
    stripped = message.strip()
    return stripped.startswith('#rw ')


def strip_prefix(message: str) -> str:
    """Remove the #rw prefix from the message."""
    stripped = message.strip()
    if stripped.startswith('#rw '):
        return stripped[4:]
    return message


def format_learning_context(original: str, improved: str) -> str:
    """Format the learning context showing both versions and instructing Claude."""
    return f"""📝 Original prompt from user:
{original}

✨ Improved prompt (grammatically corrected and clarified):
{improved}

---
**Instructions for Claude:** Please respond to the IMPROVED PROMPT above. The user wants to learn English, so they can see both versions to understand the improvements made.
"""


def main():
    try:
        # Read hook data from stdin
        stdin_data = sys.stdin.read()
        hook_data = json.loads(stdin_data)

        # Extract user message from the 'prompt' field
        user_message = hook_data.get('prompt', '')

        # Check if we should rewrite
        if not should_rewrite(user_message):
            # No rewrite needed, pass through
            sys.exit(0)

        # Strip prefix and rewrite
        original_prompt = strip_prefix(user_message)
        improved_prompt = call_rewriter_service(original_prompt)

        # If rewriting failed (service unavailable), use original
        if improved_prompt == original_prompt:
            print("⚠️  AI rewriter service unavailable, using original prompt", file=sys.stderr)
            sys.exit(0)

        # Create response with additionalContext
        # This adds both versions to Claude's context with instructions
        response = {
            "hookSpecificOutput": {
                "hookEventName": "UserPromptSubmit",
                "additionalContext": format_learning_context(original_prompt, improved_prompt)
            }
        }

        # Write response to stdout
        print(json.dumps(response))
        sys.exit(0)

    except Exception as error:
        # On error, don't block Claude - just log and pass through
        print(f"Prompt rewriter error: {error}", file=sys.stderr)
        sys.exit(0)


if __name__ == '__main__':
    main()
