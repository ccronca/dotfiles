---
name: inbox-learner
description: Process URLs from Obsidian inbox, scrape content, create concise summaries with topic tags, and link related entries for knowledge tracking
---

# Inbox Learning Processor

## Instructions

This skill delegates URL processing to the `inbox-processor` subagent, which runs autonomously with restricted permissions and uses the Haiku model for cost efficiency.

**Your task**: Launch the inbox-processor agent to handle the work.

## Delegation Strategy

Use the Task tool to launch the `inbox-processor` subagent:

```
Task:
  subagent_type: inbox-processor
  prompt: "Process all URLs from the Obsidian inbox and create learning summaries. Use today's actual date (YYYY-MM-DD format) for all file names, frontmatter dates, and archive entries."
  description: "Process inbox URLs"
  model: haiku
```

The agent will autonomously:
1. Read the inbox
2. Fetch and process each URL
3. Create learning entries
4. Link related topics
5. Archive processed URLs
6. Report back with results

### Fetching Strategy

**Primary: WebFetch**
- Fast and lightweight
- Works for most static and server-rendered pages
- No browser overhead

**Fallback: Puppeteer Script**
- For JavaScript-rendered pages (React, Vue, Framer, etc.)
- Runs in sandboxed Chrome with security enabled
- Located at `${CLAUDE_SKILL_ROOT}/fetch-page.js`
- Usage: `cd ${CLAUDE_SKILL_ROOT} && node fetch-page.js "https://example.com"`

**Detection**: If WebFetch returns mostly CSS/JS or very little text content, automatically try Puppeteer fallback.

### Summary Requirements

**Keep summaries concise** - the goal is to provide enough information to:
- Understand what the content is about
- Decide if you want to read the full article
- Find it later when searching for related topics
- Recall technical details without re-reading the full article

**Summary Structure**:
- **Title**: Descriptive title based on content
- **Source**: Original URL
- **Date**: Processing date
- **Topics**: Tags for easy searching (e.g., `#security`, `#prompt-injection`, `#supply-chain`)
- **Summary**: 2-3 paragraphs capturing the essence
- **Key Points**: 3-5 bullet points with main takeaways
- **Technical Insights**: Implementation details, code patterns, techniques, or technical concepts
- **Related**: Links to other learning entries with similar topics

### File Naming Convention

Use descriptive, slug-style names based on the main topic:
- Format: `YYYY-MM-DD-topic-name.md` where YYYY-MM-DD is **today's date**
- Example (if today is 2026-03-03): `2026-03-03-prompt-injection-cline.md`
- Example (if today is 2026-03-03): `2026-03-03-github-repo-data-leak.md`

**IMPORTANT:** Always use today's actual date, not the example dates shown above.

### Topic Extraction

Extract topics that help with discoverability:
- **Technology**: Programming languages, frameworks, tools
- **Concepts**: Design patterns, security concepts, best practices
- **Domain**: Security, DevOps, AI, databases, etc.
- **Specific**: Product names, vulnerabilities, techniques

### Linking Strategy

After creating each entry:
1. Search existing `Learning/` entries for related topics using `mcp__mcp-obsidian-myjournal__obsidian_simple_search`
2. If related entries found (matching topics/tags):
   - Add link to new entry: `Related: [[other-entry]]`
   - Update related entry to link back: `See also: [[new-entry]]`
3. This creates a knowledge graph for easy navigation

### Archive Process

After successfully processing each URL:

1. **Read Archive**: Get contents of `00_Inbox_Archive.md` (create if doesn't exist)
2. **Append Entry**: Add to archive under the **current month heading** with format:
   ```markdown
   - [YYYY-MM-DD] [URL] → [[learning-entry-name]]
   ```
3. **Remove from Inbox**: Delete the URL line from `00_Inbox.md`

**IMPORTANT - Monthly Grouping:**
- Entries are grouped by **month name** (e.g., `### March`), NOT by day
- Use heading format: `### Month Name` (e.g., `### March`, `### February`)
- **NEVER create day-based headings** like `### 2026-03-04`
- All entries from the same month go under the same month heading
- The date in brackets `[YYYY-MM-DD]` provides the specific day information

**Archive Structure** (example showing entries from different dates in the same month):
```markdown
# Processed Inbox Items

Archive of URLs processed from the inbox with links to their learning entries.

## 2026

### March
- [2026-03-03] https://example.com/article → [[2026-03-03-topic-name]]
- [2026-03-15] https://example.com/another → [[2026-03-15-another-topic]]
- [2026-03-28] https://example.com/third → [[2026-03-28-third-topic]]

### February
- [2026-02-26] https://example.com/other → [[2026-02-26-other-topic]]

### January
- [2026-01-15] https://example.com/old-article → [[2026-01-15-old-topic]]
```

**Note:** Use today's actual date when adding new entries, not the example dates above.

This provides:
- **Audit trail**: See what was processed and when
- **Quick access**: Jump to learning entries from URLs
- **History**: Track learning over time

### Template for Knowledge Entries

**IMPORTANT:** Replace YYYY-MM-DD with today's actual date in all fields below.

```markdown
---
date: YYYY-MM-DD
source: [original URL]
topics: [tag1, tag2, tag3]
---

# [Title]

**Source**: [Article Title](URL)
**Date Processed**: YYYY-MM-DD
**Topics**: #tag1 #tag2 #tag3

## Summary

[2-3 concise paragraphs explaining what this is about]

## Key Points

- Point 1
- Point 2
- Point 3

## Technical Insights

[Technical details, implementation notes, code patterns, or specific techniques mentioned]

Examples:
- Code snippets or commands
- Configuration patterns
- Attack vectors or defense mechanisms
- API usage examples
- Architectural patterns

## Related

- [[other-entry-name]] - Brief context on the connection
```

### Output to User

After processing, provide:
1. Count of URLs processed
2. List of created files with their main topics
3. Any linking relationships established
4. Archive status confirmation
5. Summary of what was learned (optional)

### Error Handling

- If URL fails to fetch, note it in archive with error marker and continue
- If no URLs found in inbox, inform user
- If `Learning/` folder doesn't exist, create it first
- If archive file doesn't exist, create it with proper structure

### Important Notes

- **Conciseness is key**: Don't replicate the full article, just capture the essence
- **Technical depth**: Include enough technical detail to jog memory without re-reading
- **Searchability**: Use consistent topic tags
- **Connections**: The real value is in linking related concepts
- **Audit trail**: Archive maintains history of learning journey
- **Iterative**: The knowledge base grows more valuable over time

---
