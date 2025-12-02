Generate a standup summary based on yesterday's development and Jira journal entries.

**Steps:**

1. **Determine the "yesterday" date:**
   - If today is Monday (day 1), use last Friday (subtract 3 days)
   - If today is Sunday (day 0), use last Friday (subtract 2 days)
   - Otherwise, use yesterday (subtract 1 day)
   - Format as YYYY-MM-DD

2. **Fetch journal entries from Obsidian:**
   - Development journal: `Journal/Development/YYYY-MM-DD.md`
   - Jira journal: `Journal/Jira/YYYY-MM-DD.md`

   Use `mcp__mcp-obsidian-myjournal__obsidian_get_file_contents` for each file.

   If either file doesn't exist, inform the user which journal entry is missing and suggest running `/journal` or `/jira-journal` first.

3. **Fetch previous standup entry:**
   - Calculate the previous standup date (2 days ago, or Friday if today is Monday/Tuesday)
   - Try to fetch: `Journal/Standup/YYYY-MM-DD.md` for the previous date
   - If it exists, extract the "What will I accomplish today?" section
   - This will be used to compare planned vs actual work

4. **Analyze the journal entries and previous standup:**
   - Extract key accomplishments from both journals
   - If previous standup exists, compare yesterday's accomplishments with what was planned
   - Identify any planned tasks that were not completed
   - Identify any blockers, issues, or challenges mentioned
   - Note incomplete tasks or follow-up items for today

5. **Generate standup summary:**
   Create a concise standup update following this format:

   ```
   # Standup Update - [Today's Date]

   **What did I accomplish yesterday?**
   - [Brief summary of key accomplishments from development journal]
   - [Summary of Jira tickets worked on and their status]
   - [Notable achievements or completions]

   **What will I accomplish today?**
   - [Incomplete tasks from previous standup that should carry over]
   - [Follow-up items from yesterday's work]
   - [Planned tasks based on journal entries]
   - [Next steps for in-progress tickets]

   **Do I have any blockers?**
   - [List any blockers mentioned in journals]
   - [List any issues or challenges encountered]
   - None (if no blockers found)

   Tags: #standup #meeting [additional tags based on work]
   ```

   **Important notes on standup comparison:**
   - If previous standup exists and shows planned tasks that were not completed yesterday, prioritize them in today's "What will I accomplish today?" section
   - Briefly note in the accomplishments if planned items were completed (shows accountability)
   - If tasks were planned but not done and no blocker is mentioned, consider if they should be carried over

6. **Formatting guidelines:**
   - Keep each section concise (2-4 bullet points maximum)
   - Use B2-level English
   - Focus on outcomes and impact, not technical details
   - No emojis
   - Professional tone suitable for standup meetings

7. **Save and output the summary:**
   - Save the standup summary to Obsidian at `Journal/Standup/YYYY-MM-DD.md` (using today's date, not yesterday's)
   - The complete content should include:
     - Header: `# Standup Update - YYYY-MM-DD`
     - The three standup sections (What accomplished, What will accomplish, Blockers)
     - Tags at the end
   - Use `mcp__mcp-obsidian-myjournal__obsidian_append_content` to save the complete entry
   - If the file already exists, it will append (user might run standup multiple times)
   - Add appropriate tags at the end of the entry:
     - Always include: `#standup #meeting`
     - Add `#workstream/[project-name]` based on tickets/work mentioned
     - Add technology tags based on work (e.g., `#dbt`, `#python`, `#postgresql`)
   - Format tags like: `Tags: #standup #meeting #workstream/pdm #dbt`
   - Display the formatted standup summary to the user

**Example output:**

```
# Standup Update - 2025-12-02

**What did I accomplish yesterday?**
- Completed dbt model refactoring for mart_finding_product_details
- Fixed unit tests for bridge table mappings with lifecycle columns
- Reviewed and merged MR for upstream subtree update
- Updated PDM-1234 status to Review and added implementation notes

**What will I accomplish today?**
- Address code review feedback on the dbt model MR
- Create unit tests for the new data quality checks
- Start work on PDM-1235 for ingestion pipeline optimization

**Do I have any blockers?**
- None

Tags: #standup #meeting #workstream/pdm #dbt #jira
```

**Important:**
- Always check for both journal entries before proceeding
- If journals are missing, guide the user to create them first
- Check the previous standup entry to compare planned vs actual work
- Carry over incomplete tasks from previous standup to today's plan
- Focus on actionable items and clear communication
- Show accountability by noting when planned items were completed
