#!/usr/bin/env python3
"""
Stop Hook: Validate Work Completion
Checks if assistant is rationalizing incomplete work or making excuses
"""

import json
import sys
import re


def clean_json_response(text):
    """Remove markdown code fences and extract JSON."""
    # Remove ```json and ``` markers
    text = re.sub(r'^```json\s*\n?', '', text, flags=re.MULTILINE)
    text = re.sub(r'\n?```\s*$', '', text, flags=re.MULTILINE)

    # Try to find JSON object
    match = re.search(r'\{[^}]*\}', text, re.DOTALL)
    if match:
        return match.group(0)

    return text.strip()


def check_for_incomplete_work_patterns(response_text):
    """
    Check if the response contains patterns indicating incomplete work.
    Returns (is_incomplete, reason) tuple.
    """
    # Lowercase for pattern matching
    lower_text = response_text.lower()

    # Patterns that suggest incomplete work
    patterns = [
        (r'\bpre-?existing\b', "claiming issues are pre-existing"),
        (r'\bout of scope\b', "claiming work is out of scope"),
        (r'\btoo many (issues|problems|errors)\b', "saying there are too many issues to fix"),
        (r'\bfollow-?up\b.*\b(ticket|issue|task)\b', "deferring to unrequested follow-ups"),
        (r'\bwill (fix|address|handle)\b.*\blater\b', "deferring work to later"),
        (r'\bknown (issue|problem|bug)\b.*\bnot fix(ing|ed)?\b', "acknowledging but not fixing known issues"),
        (r'\btest(s)? (fail|failing)\b.*\b(but|however|expected)\b', "rationalizing test failures"),
        (r'\blint(er)? (error|warning|fail)\b.*\b(skip|ignore|acceptable)\b', "rationalizing lint failures"),
        (r'\bhere (are|is) the (problem|issue)s?\b(?!.*\bfixed\b)', "listing problems without fixing them"),
    ]

    for pattern, reason in patterns:
        if re.search(pattern, lower_text, re.IGNORECASE):
            return True, reason

    return False, None


def main():
    try:
        # Read hook data from stdin
        stdin_data = sys.stdin.read()
        hook_data = json.loads(stdin_data)

        # Get the assistant's last response
        messages = hook_data.get('conversation', {}).get('messages', [])
        if not messages:
            # No messages to validate
            sys.exit(0)

        # Get last assistant message
        last_message = None
        for msg in reversed(messages):
            if msg.get('role') == 'assistant':
                last_message = msg.get('content', '')
                break

        if not last_message:
            # No assistant message to validate
            sys.exit(0)

        # Check for incomplete work patterns
        is_incomplete, reason = check_for_incomplete_work_patterns(last_message)

        if is_incomplete:
            # Reject: work appears incomplete
            result = {
                "ok": False,
                "reason": f"You are rationalizing incomplete work: {reason}. Go back and finish."
            }
            print(json.dumps(result))
            sys.exit(1)
        else:
            # Accept: work appears complete
            result = {"ok": True}
            print(json.dumps(result))
            sys.exit(0)

    except json.JSONDecodeError as e:
        # If we can't parse the hook data, don't block Claude Code
        print(json.dumps({"ok": True, "note": f"Validation skipped: JSON parse error"}), file=sys.stderr)
        sys.exit(0)
    except Exception as e:
        # Don't block Claude Code on errors
        print(json.dumps({"ok": True, "note": f"Validation skipped: {str(e)}"}), file=sys.stderr)
        sys.exit(0)


if __name__ == '__main__':
    main()
