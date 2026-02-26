---
name: gemini-reviewer
description: Use Google Gemini for parallel code reviews, complex task validation, and second opinions. Runs Gemini CLI non-interactively to provide alternative perspectives on code quality, implementation decisions, and technical solutions.
---

# Gemini Reviewer Skill

**IMPORTANT:** This skill executes automatically. When invoked, follow these steps precisely.

## Execution Protocol

When this skill is invoked, you MUST:

1. **Identify the review target** from conversation context:
   - Look for PR/MR numbers mentioned
   - Look for commit hashes mentioned
   - Look for code snippets or implementation plans
   - Check recent tool calls (glab mr view, gh pr view, git diff, etc.)

2. **Prepare comprehensive review context** file:
   - Include MR/PR title and description
   - Include all code changes (diff)
   - Include relevant file contents
   - Include upstream issues or comments
   - Include helper functions or related code

3. **Execute Gemini review** using Bash tool with safety restrictions:
   ```bash
   gemini --approval-mode plan -o text "You are an expert code reviewer. Review this [MR/PR/code] and provide detailed feedback on correctness, security, performance, code quality, and testing. Be specific and reference line numbers or code sections." < /tmp/gemini_context.txt
   ```

   **SECURITY NOTE**: Uses `--approval-mode plan` (read-only mode) instead of `-y` (YOLO mode) to prevent Gemini from executing any tools. Gemini can only analyze the provided context and return text feedback.

4. **Return the complete Gemini output** - do not summarize or filter

## Context File Template

Create `/tmp/gemini_context.txt` with this structure:

```
Review [GitLab MR/GitHub PR/Commit] #[NUMBER]: "[TITLE]"

## CONTEXT

**Purpose:** [What this change does]

**Related Issues:** [Links to upstream issues, bugs, etc.]

**Rationale:** [Why this change is needed]

**CI Status:** [Pipeline/test results if available]

## CHANGES SUMMARY

[High-level summary of what files changed and why]

## DETAILED CODE CHANGES

### File: [filename]
```[language]
[Show diff with - and + for removed/added lines]
```

### File: [filename2]
```[language]
[Show diff]
```

## HELPER FUNCTION CONTEXT

[Include any related helper functions or dependencies that aren't in the diff]

## REVIEW FOCUS

Please review focusing on:
1. Correctness: Logic errors, edge cases
2. Security: Input validation, vulnerabilities
3. Performance: Scalability, efficiency concerns
4. Edge Cases: Null handling, error conditions
5. Architecture: Design soundness, alternatives
6. Code Quality: Readability, maintainability
7. Testing: What tests should be added?
8. Configuration: Impact of config changes

Provide specific, actionable feedback with line references.
```

## Example Execution

**Scenario:** /code-review command called with MR 44

**Step 1:** Identify target
- MR 44 mentioned in conversation
- Recent `glab mr view 44` and `glab mr diff 44` calls

**Step 2:** Prepare context file using Bash tool
```bash
cat > /tmp/gemini_context.txt << 'EOF'
Review GitLab Merge Request #44: "Tuning rag score thresholds"

## CONTEXT
[Full MR description, purpose, rationale]

## DETAILED CODE CHANGES
[Complete diff from glab mr diff]

## REVIEW FOCUS
[Specific areas to examine]
EOF
```

**Step 3:** Execute Gemini (read-only mode)
```bash
gemini --approval-mode plan -o text "You are an expert code reviewer. Review this merge request..." < /tmp/gemini_context.txt
```

**Step 4:** Return output
Present the complete Gemini response without modification.

## Critical Rules

- **ALWAYS use `--approval-mode plan`** (read-only mode) for safe, non-interactive execution - prevents tool execution
- **NEVER use `-y`/YOLO mode** - this auto-approves dangerous tool executions (rm, git reset, etc.)
- **ALWAYS use `-o text`** for clean text output
- **DO NOT** summarize or filter Gemini's output - return it verbatim
- **DO gather sufficient context** - include diffs, descriptions, related code
- **DO focus the prompt** - tell Gemini what to look for
- **DO use temporary files** (`/tmp/gemini_context.txt`) for large context

## Troubleshooting

**If Gemini is not installed:**
- Report to user that Gemini CLI is not available
- Skip Gemini review and note it in the combined output

**If Gemini returns an error:**
- Include the error in the output
- Note that Gemini review failed but continue with other reviews

## Integration with /code-review

This skill is automatically invoked by `/code-review` command alongside Claude's code-reviewer agent. Both run in parallel for comprehensive coverage.
