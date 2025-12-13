---
name: claude-docs
description: Consult official Claude Code documentation from docs.claude.com using selective fetching. Use this skill when working on Claude Code hooks, skills, subagents, MCP servers, or any Claude Code feature that requires referencing official documentation for accurate implementation. Fetches only the specific documentation needed rather than loading all docs upfront.
---

# Claude Docs

## Overview

This skill enables efficient consultation of official Claude Code documentation by fetching only the specific docs needed for the current task.

## When to Use This Skill

Invoke this skill when:

- Creating or modifying Claude Code hooks
- Building or debugging skills
- Working with subagents or understanding subagent parameters
- Implementing MCP server integrations
- Understanding any Claude Code feature that requires official documentation
- Troubleshooting Claude Code functionality
- Verifying correct API usage or parameters

## Common Documentation

For the most frequently referenced topics, fetch these detailed documentation files directly:

### Hooks Documentation

- **hooks-guide.md** - Guide to creating hooks with examples and best practices
  - URL: `https://code.claude.com/docs/en/hooks-guide.md`
  - Use for: Understanding hook lifecycle, creating new hooks, examples

- **hooks.md** - Hooks API reference with event types and parameters
  - URL: `https://code.claude.com/docs/en/hooks.md`
  - Use for: Hook event reference, available events, parameter details

### Skills Documentation

- **skills.md** - Skills creation guide and structure reference
  - URL: `https://code.claude.com/docs/en/skills.md`
  - Use for: Creating skills, understanding SKILL.md format, bundled resources

### Subagents Documentation

- **sub-agents.md** - Subagent types, parameters, and usage
  - URL: `https://code.claude.com/docs/en/sub-agents.md`
  - Use for: Available subagent types, when to use Task tool, subagent parameters

## Workflow for Selective Fetching

Follow this process to efficiently fetch documentation:

### Step 1: Identify Documentation Needs

Determine which documentation is needed based on the task:

- **Hook-related task** → Fetch `hooks-guide.md` and/or `hooks.md`
- **Skill-related task** → Fetch `skills.md`
- **Subagent-related task** → Fetch `sub-agents.md`
- **Other Claude Code feature** → Proceed to Step 2

### Step 2: Discover Available Documentation (If Needed)

For features not covered by the 4 common docs above, fetch the docs map to discover available documentation:

```
URL: https://code.claude.com/docs/en/claude_code_docs_map.md
```

The docs map lists all available Claude Code documentation with descriptions. Identify the relevant doc(s) from the map.

### Step 3: Fetch Only Relevant Documentation

Use WebFetch to retrieve only the specific documentation needed:

```
WebFetch:
  url: https://code.claude.com/docs/en/[doc-name].md
  prompt: "Extract the full documentation content"
```

Fetch multiple docs in parallel if the task requires information from several sources.

### Step 4: Apply Documentation to Task

Use the fetched documentation to:

- Verify correct API usage
- Understand available parameters and options
- Follow best practices and examples
- Implement the feature correctly

## Examples

**Creating a hook:**
1. Fetch `hooks-guide.md` for creation process and examples
2. Fetch `hooks.md` for event reference
3. Create hook with correct parameters

**Debugging a skill:**
1. Fetch `skills.md` for SKILL.md format requirements
2. Validate frontmatter and structure

**Using subagents:**
1. Fetch `sub-agents.md` for subagent types and capabilities
2. Select appropriate subagent

**Unknown feature (e.g., settings.json):**
1. Fetch docs map: `claude_code_docs_map.md`
2. Identify relevant doc (e.g., `settings.md`)
3. Fetch specific doc and apply

## Best Practices

- Fetch only the documentation needed for the current task
- Fetch multiple docs in parallel when needed
- Always fetch from docs.claude.com for latest information
- Use docs map for discovery when common docs don't cover the need

## Attribution

Based on the [claude-docs-consultant](https://github.com/centminmod/my-claude-code-setup/tree/master/.claude/skills/claude-docs-consultant) skill by centminmod.