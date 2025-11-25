Generate a Jira work journal entry summarizing tickets worked on during a specific time period.

**Usage:**
- `/jira-journal` - Summary for today
- `/jira-journal week` - Summary for current week
- `/jira-journal YYYY-MM-DD` - Summary for specific date

**Steps:**

1. **Parse the time period:**
   - If no argument: use today's date
   - If "week": use current week (Monday-Sunday)
   - If date format (YYYY-MM-DD): use that specific date

2. **Query Jira for tickets:**
   Use the `jira` CLI to fetch tickets you've worked on during the period:
   ```bash
   # For today
   jira issue list --assignee $(jira me) --updated "-1d" --plain --columns key,summary,status,updated

   # For this week
   jira issue list --assignee $(jira me) --updated "-7d" --plain --columns key,summary,status,updated

   # For specific date
   jira issue list --assignee $(jira me) --jql "updated >= '2025-11-21' AND updated <= '2025-11-25'" --plain --columns key,summary,status,updated
   ```

3. **Fetch detailed information for each ticket:**
   For each ticket found, get:
   - Issue key and summary
   - Current status
   - Recent comments you've added
   - Recent worklogs
   - Status transitions during the period

   Use: `jira issue view KEY --comments 5 --plain`

4. **Generate summary:**
   Create a narrative summary that includes:
   - List of tickets worked on
   - What was accomplished on each ticket
   - Status changes (e.g., moved from In Progress to Review)
   - Time spent (from worklogs if available)
   - Key activities and decisions
   - Any blockers or issues encountered

5. **Create Obsidian journal entry:**
   Save to `Journal/Jira/YYYY-MM-DD.md` (or `Journal/Jira/YYYY-Www.md` for weekly summaries) with format:

   ```markdown
   # Jira Work Journal - [Date/Week]

   ## Summary
   [2-3 paragraph narrative of work accomplished]

   ## Tickets Worked On

   ### [TICKET-123] Ticket Summary
   **Status:** In Progress → Review
   **Time Spent:** 3h

   [Description of work done on this ticket]

   ### [TICKET-124] Another Ticket
   **Status:** To Do → In Progress
   **Time Spent:** 1.5h

   [Description of work done]

   ## Notes
   - Key decisions made
   - Blockers encountered
   - Follow-up items
   ```

6. **Use MCP to save:**
   Use `mcp__mcp-obsidian-myjournal__obsidian_append_content` or create new file if it doesn't exist.

7. **Add appropriate tags:**
   Analyze the tickets and their content to add relevant tags at the end of the entry:
   - Add `#workstream/[project-name]` based on the Jira project (e.g., #workstream/pdm for PDM project tickets)
   - Add `#jira` for all Jira journal entries
   - Add `#opensource` if work involves open source contributions
   - Add technology-specific tags based on ticket content (e.g., #dbt, #python, #postgresql)
   - Add activity tags like `#bugfix`, `#feature`, `#refactoring` based on work type

   Format tags at the end of the entry like:
   ```
   Tags: #jira #workstream/pdm #dbt #bugfix
   ```

**Important:**
- Focus on what was accomplished and why, not just status changes
- Include context from comments and descriptions
- Summarize technical work in clear, professional language
- Use B2-level English
- No emojis
