#!/usr/bin/env python3
"""
Simplified Event Capture Hook
Captures Claude Code hook events to date-organized JSONL files
No external dependencies - uses only Python standard library
"""

import json
import sys
from datetime import datetime
from pathlib import Path


def get_events_file_path():
    """Get current events file path organized by date."""
    now = datetime.now()
    year = now.strftime('%Y')
    month = now.strftime('%m')
    day = now.strftime('%d')

    # Store in ~/.claude/history/raw-outputs/YYYY-MM/
    month_dir = Path.home() / '.claude' / 'history' / 'raw-outputs' / f'{year}-{month}'

    # Ensure directory exists
    month_dir.mkdir(parents=True, exist_ok=True)

    return month_dir / f'{year}-{month}-{day}_all-events.jsonl'


def main():
    try:
        # Get event type from command line args
        if '--event-type' not in sys.argv:
            print('Missing --event-type argument', file=sys.stderr)
            sys.exit(0)  # Don't block Claude Code

        event_type_index = sys.argv.index('--event-type')
        event_type = sys.argv[event_type_index + 1]

        # Read hook data from stdin
        stdin_data = sys.stdin.read()
        hook_data = json.loads(stdin_data)

        # Create event object
        event = {
            'session_id': hook_data.get('session_id', 'main'),
            'event_type': event_type,
            'payload': hook_data,
            'timestamp': int(datetime.now().timestamp() * 1000),
            'timestamp_iso': datetime.now().isoformat()
        }

        # Append to events file
        events_file = get_events_file_path()
        with open(events_file, 'a', encoding='utf-8') as f:
            f.write(json.dumps(event) + '\n')

    except Exception as error:
        # Silently fail - don't block Claude Code
        print(f'Event capture error: {error}', file=sys.stderr)

    sys.exit(0)


if __name__ == '__main__':
    main()
