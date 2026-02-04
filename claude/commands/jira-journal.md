Generate a Jira work journal entry summarizing tickets worked on during a specific time period.

**Usage:**
- `/jira-journal` - Summary for today
- `/jira-journal yesterday` - Summary for yesterday (or last Friday if today is Monday/Sunday)
- `/jira-journal week` - Summary for current week
- `/jira-journal YYYY-MM-DD` - Summary for specific date

**Steps:**

1. **Parse the time period:**
   - If no argument: use today's date
   - If "yesterday": calculate yesterday's date
     - If today is Monday (day 1), use last Friday (subtract 3 days)
     - If today is Sunday (day 0), use last Friday (subtract 2 days)
     - Otherwise, use yesterday (subtract 1 day)
   - If "week": use current week (Monday-Sunday)
   - If date format (YYYY-MM-DD): use that specific date

2. **Query Jira for tickets:**
   Use the `jira` CLI to fetch tickets you've worked on during the period.

   **IMPORTANT:** Query includes issues where you are:
   - Assigned to the issue (assignee)
   - Created the issue (reporter)

   ```bash
   # For today (last 1 day)
   jira issue list --jql "updated >= -1d AND (assignee = currentUser() OR reporter = currentUser())" --plain --columns key,summary,status,updated

   # For this week (last 7 days)
   jira issue list --jql "updated >= -7d AND (assignee = currentUser() OR reporter = currentUser())" --plain --columns key,summary,status,updated

   # For specific date range
   jira issue list --jql "updated >= '2025-11-21' AND updated <= '2025-11-25' AND (assignee = currentUser() OR reporter = currentUser())" --plain --columns key,summary,status,updated
   ```

   **Note on commented issues:** Native Jira JQL doesn't support filtering by commenter without a plugin (requires ScriptRunner or similar extension). To include issues you've only commented on, you'll need to check comments manually in step 3.

3. **Fetch detailed information for each ticket:**
   For each ticket found, get:
   - Issue key and summary
   - Current status
   - Recent comments (check if you authored any)
   - Recent worklogs
   - Status transitions during the period

   Use: `jira issue view KEY --comments 10 --plain`

   **Identifying your comments:** When viewing issue details, look for comments authored by your username. The output will show:
   ```
   Comments:
   - <username> commented at <timestamp>: <comment text>
   ```

   Filter for only issues where you've added comments during the time period, or include all issues you're assigned to/created.

4. **Generate summary:**
   Create a narrative summary that includes:
   - List of tickets worked on
   - What was accomplished on each ticket
   - Status changes (e.g., moved from In Progress to Review)
   - Time spent (from worklogs if available)
   - Key activities and decisions
   - Any blockers or issues encountered

5. **Create Obsidian journal entry:**
   Save to `Work Journal/Jira/YYYY-MM-DD.md` (or `Work Journal/Jira/YYYY-Www.md` for weekly summaries) with format:

   ```markdown
   # Jira Work Journal - [Date/Week]

   ## Summary
   [2-3 paragraph narrative of work accomplished]

   ## Tickets Worked On

   ### [TICKET-123] Ticket Summary
   **Status:** In Progress → Review
   **Time Spent:** 3h
   **Role:** Assignee

   [Description of work done on this ticket, including any comments added]

   ### [TICKET-124] Another Ticket
   **Status:** To Do → In Progress
   **Time Spent:** 1.5h
   **Role:** Reporter

   [Description of work done, collaboration through comments]

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
