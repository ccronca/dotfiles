Invoke the Journaling skill to generate a development journal entry for the current session and save it to Obsidian.

The Journaling skill will analyze the session transcript and create a structured summary.

After the skill completes:

1. **Fetch GitLab MR reviews** by reading the internal command file at `.claude/commands/.internal/fetch-mr-reviews.md` and executing its instructions to get MR reviews from the last day.

2. **Create the Obsidian journal entry** in the myjournal vault at `Journal/Development/YYYY-MM-DD.md` with:
   - Session ID and timestamp
   - Working directory and duration
   - Summary and focus from the Journaling skill
   - Files modified, git operations, Jira tickets
   - GitLab MR reviews (if any were fetched in step 1)

Use the mcp-obsidian-myjournal MCP server to append the entry. If the daily note doesn't exist, create it with header "# Development Journal - YYYY-MM-DD".

Before creating the entry, analyze the session content to determine appropriate tags:
- Add `#workstream/[project-name]` if working directory or files indicate a specific project (e.g., #workstream/pdm-db, #workstream/product-security)
- Add `#opensource` if the session involves contributing to open source projects (check for upstream subtrees, external repos, or open source library work)
- Add `#development` for all development sessions
- Add specific technology tags like `#dbt`, `#python`, `#git`, etc. based on tools and files used
- Add `#code-review` if MR reviews are included in the journal

Format tags at the end of the entry like:
```
Tags: #development #workstream/pdm-db #dbt #code-review
```
