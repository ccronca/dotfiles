Generate a Google Calendar journal entry summarizing meetings for a specific time period.

**Usage:**
- `/calendar-journal` - Summary for today
- `/calendar-journal week` - Summary for current week
- `/calendar-journal YYYY-MM-DD` - Summary for specific date

**Steps:**

1. **Parse the time period:**
   - If no argument: use today's date
   - If "week": use current week (Monday-Sunday)
   - If date format (YYYY-MM-DD): use that specific date

2. **Query Google Calendar using gcalcli:**
   ```bash
   # For today
   gcalcli agenda --nocolor --tsv --details description $(date +%Y-%m-%d) $(date -d "tomorrow" +%Y-%m-%d)

   # For this week
   gcalcli agenda --nocolor --tsv --details description $(date -d "last monday" +%Y-%m-%d) $(date -d "next monday" +%Y-%m-%d)

   # For specific date
   gcalcli agenda --nocolor --tsv --details description YYYY-MM-DD $(date -d "YYYY-MM-DD + 1 day" +%Y-%m-%d)
   ```

   The `--tsv --details description` flags output tab-separated values for easier parsing:
   - Start date, Start time, End date, End time, Event title, Description

3. **Parse calendar events:**
   For each event from gcalcli output, extract:
   - Event title and description
   - Start and end time (calculate duration)
   - Time of day (morning 9am-12pm, afternoon 12pm-5pm, evening 5pm+)
   - Infer meeting type from title patterns:
     - 1:1 if contains "1:1", "1-1", "one-on-one", or two person names
     - Team meeting if contains "standup", "sync", "team", "all hands"
     - Planning if contains "planning", "sprint", "retrospective"
     - Customer/external if contains "customer", "client", "demo"

4. **Generate summary:**
   Create a narrative summary that includes:
   - Total meeting time and number of meetings
   - Distribution across meeting types
   - Distribution across time of day (morning/afternoon/evening)
   - Notable patterns:
     - Back-to-back meetings (less than 15 min gap)
     - Focus time blocks (1+ hour gaps between meetings)
     - Meeting-heavy vs focus-time ratio
     - Longest meeting

5. **Create Obsidian journal entry:**
   Save to `Journal/Calendar/YYYY-MM-DD.md` (or `Journal/Calendar/YYYY-Www.md` for weekly summaries) with format:

   ```markdown
   # Calendar Journal - [Date/Week]

   ## Summary
   [2-3 paragraph narrative of meeting patterns, time distribution, and notable observations]

   ## Meeting Breakdown

   ### Morning (9am-12pm)
   - **09:00-09:30** Team Standup (30min)
   - **10:00-11:00** 1:1 with Manager (1h)

   ### Afternoon (12pm-5pm)
   - **14:00-15:30** Sprint Planning (1.5h)
   - **16:00-16:30** Customer Sync (30min)

   ### Evening (5pm+)
   - No meetings scheduled

   ## Statistics
   - **Total Meeting Time:** 3.5 hours
   - **Number of Meetings:** 4
   - **Meeting Types:**
     - 1:1 meetings: 1 (1h)
     - Team meetings: 2 (2h)
     - Customer meetings: 1 (30min)
   - **Time Distribution:**
     - Morning: 1.5h (2 meetings)
     - Afternoon: 2h (2 meetings)
     - Evening: 0h (0 meetings)

   ## Observations
   - Focus time available: [list time blocks]
   - Back-to-back meetings: [count and times]
   - Longest meeting: [title] (duration)
   - Meeting-free time: [percentage or hours]

   Tags: #calendar #meetings [additional context tags]
   ```

6. **Add appropriate tags:**
   Analyze the meetings and meeting patterns to add relevant tags:
   - `#calendar` for all calendar journal entries
   - `#meetings` for meeting summaries
   - `#workstream/[project]` if meeting titles indicate specific projects (e.g., #workstream/pdm if multiple PDM-related meetings)
   - Meeting density tags:
     - `#heavy-meeting-day` if >50% of work hours in meetings
     - `#focus-day` if <25% of work hours in meetings
     - `#balanced-day` if 25-50% in meetings
   - Meeting type tags based on prevalence:
     - `#many-1on1s` if 3+ one-on-one meetings
     - `#team-sync-heavy` if multiple team meetings

   Format tags at the end of the entry.

7. **Use MCP to save:**
   Use `mcp__mcp-obsidian-myjournal__obsidian_append_content` to add the entry to the daily or weekly note. If the file doesn't exist, create it with the appropriate header.

**Important:**
- Focus on time distribution and meeting patterns, not just listing meetings
- Identify meeting-heavy vs focus time periods
- Use B2-level English
- No emojis
- Respect privacy: include meeting titles and descriptions but DO NOT include attendee lists
- Calculate accurate durations by parsing start and end times
- Categorize by time of day to show daily rhythm
- Note any unusual patterns (all morning meetings, scattered schedule, etc.)
