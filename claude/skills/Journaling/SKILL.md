---
name: work-session-journaler
description: Generates a detailed summary of a development session by analyzing the session transcript. Can be invoked manually or automatically from hooks.
---

# Work Session Journaler

## Instructions

This skill analyzes a Claude Code session transcript and generates an intelligent summary.

### Input Methods

**Method 1: Current Session (Manual)**
- When invoked during an active session, analyze the current conversation context

**Method 2: Transcript File (Hook/Automated)**
- Read the transcript file path from the user's message
- Expected format: "Analyze session transcript: /path/to/transcript.jsonl"
- Parse the JSONL transcript file to extract messages and tool usage

### Analysis Requirements

1. **Read the Transcript**: Use the Read tool to load the transcript file (if path provided)
2. **Extract Key Information**:
   - User messages (extract text from both string and structured content)
   - Tool calls (Edit, Write, Bash commands, etc.)
   - Working directory (cwd)
   - Session progression

3. **Analyze and Summarize**:
   - **Main Focus**: What was the primary goal/task?
   - **Work Accomplished**: What specific changes were made?
   - **Problems Solved**: What issues were addressed?
   - **Files Modified**: Which files were edited/created?
   - **Git Operations**: Commits, PRs, branches
   - **JIRA/Tickets**: Any ticket references
   - **Tools Used**: Key tools and their usage

4. **Generate Summary**: Create a concise 2-3 paragraph narrative that tells the story of what happened in the session

### Output Format

Return a JSON object with the following structure that will be used to create the session summary file:

```json
{
  "summary": "Concise narrative summary (2-3 paragraphs)",
  "focus": "Main focus/theme of the session",
  "files_modified": ["file1.py", "file2.js"],
  "git_operations": ["commit", "push", "pr_create"],
  "jira_tickets": ["JIRA-123"],
  "tools_used": ["Bash", "Edit", "Read"],
  "working_directory": "/path/to/project"
}
```

### Important Notes

- Focus on **what** was accomplished and **why**, not **how**
- Identify patterns and themes across the session
- Extract meaningful context from the conversation flow
- Be concise but informative
- If invoked from a hook, the output will be captured and used to create the session summary file

---
