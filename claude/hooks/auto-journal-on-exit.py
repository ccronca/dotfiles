#!/usr/bin/env python3
"""
Auto-Journal on Session End Hook

Automatically generates a journal entry when a Claude Code session ends.
This runs as a SessionEnd hook and creates a basic journal entry from the transcript.

NOTE: This creates simplified journal entries as a fallback. For better quality entries
      with AI analysis, remember to run /journal before exiting the session.

The hook journals all sessions automatically. To skip journaling for a session,
run /journal manually during the session.
"""

import html
import json
import os
import re
import sys
from datetime import datetime
from pathlib import Path


def parse_transcript(transcript_path: str) -> dict:
    """Parse transcript file and extract key information."""
    data = {
        'files_modified': set(),
        'files_read': set(),
        'bash_commands': [],
        'user_prompts': [],
    }

    try:
        with open(transcript_path, 'r', encoding='utf-8') as f:
            for line in f:
                try:
                    entry = json.loads(line)

                    # Skip non-message entries
                    if entry.get('type') not in ('user', 'assistant'):
                        continue

                    message = entry.get('message', {})

                    # Extract user prompts
                    if entry.get('type') == 'user':
                        content = message.get('content', '')
                        if isinstance(content, str) and content.strip():
                            data['user_prompts'].append(content.strip()[:100])

                    # Extract tool uses from assistant messages
                    if entry.get('type') == 'assistant':
                        content = message.get('content', [])
                        if isinstance(content, list):
                            for item in content:
                                if isinstance(item, dict) and item.get('type') == 'tool_use':
                                    tool_name = item.get('name', '')
                                    tool_input = item.get('input', {})

                                    # File operations
                                    if tool_name in ('Write', 'Edit'):
                                        file_path = tool_input.get('file_path', '')
                                        if file_path:
                                            data['files_modified'].add(file_path)

                                    elif tool_name == 'Read':
                                        file_path = tool_input.get('file_path', '')
                                        if file_path:
                                            data['files_read'].add(file_path)

                                    # Bash commands
                                    elif tool_name == 'Bash':
                                        command = tool_input.get('command', '')
                                        if command:
                                            data['bash_commands'].append(command)

                except (json.JSONDecodeError, Exception):
                    continue

    except Exception:
        pass

    return data


def format_duration(start_iso: str, end_iso: str) -> str:
    """Calculate and format session duration."""
    try:
        start = datetime.fromisoformat(start_iso.replace('Z', '+00:00'))
        end = datetime.fromisoformat(end_iso.replace('Z', '+00:00'))
        duration = end - start

        hours = duration.seconds // 3600
        minutes = (duration.seconds % 3600) // 60

        if hours > 0:
            return f"{hours}h {minutes}m"
        else:
            return f"{minutes}m"
    except (ValueError, AttributeError, TypeError):
        return "unknown"


def generate_journal_entry(hook_data: dict, transcript_data: dict) -> str:
    """Generate a journal entry from session and transcript data."""
    session_id = hook_data.get('session_id', 'unknown')
    session_id_short = session_id[:8]

    cwd = hook_data.get('cwd', 'unknown')
    # Escape HTML special characters in paths
    cwd_escaped = html.escape(cwd)

    transcript_path = hook_data.get('transcript_path', '')

    # Get timestamps from payload or use current time
    end_time = datetime.now().isoformat()

    entry = f"""
## Session {session_id_short}

**Note:** Auto-generated from transcript (you forgot to run /journal). For better quality entries, remember to use /journal at the end of sessions.

- **Working Directory:** `{cwd_escaped}`
- **Session ID:** `{session_id}`
- **End Time:** {end_time[:19]}
- **Transcript:** [{session_id_short}]({transcript_path})
"""

    # User activity summary
    if transcript_data['user_prompts']:
        entry += "\n**Session Activity:**\n"
        for prompt in transcript_data['user_prompts'][:5]:
            # Escape HTML special characters to prevent interpretation
            escaped_prompt = html.escape(prompt)
            entry += f"- {escaped_prompt}\n"
        if len(transcript_data['user_prompts']) > 5:
            entry += f"- ... and {len(transcript_data['user_prompts']) - 5} more prompts\n"

    # Files (combine modified and read)
    all_files = transcript_data['files_modified'] | transcript_data['files_read']
    if all_files:
        entry += "\n**Files:**\n"
        for file_path in sorted(all_files)[:15]:
            entry += f"- `{file_path}`\n"
        if len(all_files) > 15:
            entry += f"- ... and {len(all_files) - 15} more files\n"

    entry += "\n---\n"

    return entry


def check_if_already_journaled(session_id: str, date_str: str) -> bool:
    """Check if session is already in the journal."""
    try:
        # Use environment variable for vault path or default
        vault_path = os.environ.get('OBSIDIAN_VAULT_PATH', str(Path.home() / 'myjournal'))
        journal_file = Path(vault_path) / 'Work Journal' / 'Development' / f'{date_str}.md'

        if journal_file.exists():
            content = journal_file.read_text()
            session_id_short = session_id[:8]
            return session_id_short in content

    except Exception:
        pass

    return False


def replace_session_in_journal(date_str: str, session_id: str, new_entry: str) -> bool:
    """Replace existing session entry in journal."""
    try:
        vault_path = os.environ.get('OBSIDIAN_VAULT_PATH', str(Path.home() / 'myjournal'))
        journal_file = Path(vault_path) / 'Work Journal' / 'Development' / f'{date_str}.md'

        if not journal_file.exists():
            return False

        content = journal_file.read_text(encoding='utf-8')
        session_id_short = session_id[:8]

        # Find the session section using regex
        # Pattern: ## Session {id} ... up to the next --- or end of file
        pattern = rf'(## Session {re.escape(session_id_short)}.*?)(?=\n## Session |\Z)'

        # Check if session exists
        if not re.search(pattern, content, re.DOTALL):
            return False

        # Replace the session section
        new_content = re.sub(pattern, new_entry.rstrip() + '\n', content, flags=re.DOTALL)
        journal_file.write_text(new_content, encoding='utf-8')

        return True

    except Exception as e:
        print(f"Failed to replace session in journal: {e}", file=sys.stderr)
        return False


def append_to_journal(date_str: str, entry: str) -> bool:
    """Append entry to Obsidian journal."""
    try:
        vault_path = os.environ.get('OBSIDIAN_VAULT_PATH', str(Path.home() / 'myjournal'))
        journal_file = Path(vault_path) / 'Work Journal' / 'Development' / f'{date_str}.md'

        # Create directory if it doesn't exist
        journal_file.parent.mkdir(parents=True, exist_ok=True)

        # Add header if file doesn't exist
        if not journal_file.exists():
            header = f"# Development Journal - {date_str}\n\n"
            journal_file.write_text(header + entry, encoding='utf-8')
        else:
            # Append to existing file
            with open(journal_file, 'a', encoding='utf-8') as f:
                f.write(entry)

        return True

    except Exception as e:
        print(f"Failed to append to journal: {e}", file=sys.stderr)
        return False


def main():
    # Setup logging with date-based filename
    date_str = datetime.now().strftime("%Y-%m-%d")
    log_file = Path.home() / '.claude' / 'history' / f'auto-journal-{date_str}.log'
    log_file.parent.mkdir(parents=True, exist_ok=True)

    def log(message):
        timestamp = datetime.now().isoformat()
        with open(log_file, 'a', encoding='utf-8') as f:
            f.write(f"[{timestamp}] {message}\n")

    try:
        log("=== Auto-journal hook started ===")

        # Read hook data from stdin
        stdin_data = sys.stdin.read()
        log(f"Raw stdin length: {len(stdin_data)}")

        if not stdin_data or stdin_data.strip() == '':
            log("No stdin data received, exiting")
            sys.exit(0)

        hook_data = json.loads(stdin_data)
        log(f"Hook data keys: {list(hook_data.keys())}")
        log(f"Hook data: {json.dumps(hook_data, indent=2)[:500]}")

        # SessionEnd hook data is at top level, not nested in 'payload'
        session_id = hook_data.get('session_id', '')
        transcript_path = hook_data.get('transcript_path', '')
        cwd = hook_data.get('cwd', '')

        log(f"Session ID: {session_id[:8] if session_id else 'NONE'}...")
        log(f"CWD: {cwd}")
        log(f"Transcript: {transcript_path}")

        # Check if transcript exists
        if not transcript_path or not Path(transcript_path).exists():
            log("Transcript not found, skipping")
            sys.exit(0)

        log("Transcript exists")

        # Get today's date
        date_str = datetime.now().strftime("%Y-%m-%d")

        # Check if already journaled
        already_exists = check_if_already_journaled(session_id, date_str)
        if already_exists:
            log("Session already journaled (by manual /journal or previous run), skipping to preserve existing entry")
            sys.exit(0)

        log("Session not yet journaled, will create new entry")

        # Parse transcript
        transcript_data = parse_transcript(transcript_path)
        log(f"Parsed transcript: {len(transcript_data['user_prompts'])} prompts, "
            f"{len(transcript_data['files_modified'])} files modified")

        # Only create journal if there was actual activity
        if not (transcript_data['user_prompts'] or
                transcript_data['files_modified'] or
                transcript_data['files_read']):
            log("No activity in session, skipping journal")
            sys.exit(0)

        log("Activity detected, generating journal entry")

        # Generate and save journal entry
        entry = generate_journal_entry(hook_data, transcript_data)

        vault_path = os.environ.get('OBSIDIAN_VAULT_PATH', str(Path.home() / 'myjournal'))
        log(f"Writing to journal in vault: {vault_path}")

        # Append new entry (never replace existing ones)
        success = append_to_journal(date_str, entry)

        if success:
            log(f"✓ Successfully created journal entry for session {session_id[:8]}")
        else:
            log(f"✗ Failed to create journal entry for session {session_id[:8]}")

    except Exception as e:
        # Log error but don't block Claude Code
        try:
            log(f"ERROR: {str(e)}")
        except (IOError, OSError):
            pass
        print(f'Auto-journal error: {e}', file=sys.stderr)

    sys.exit(0)


if __name__ == '__main__':
    main()
