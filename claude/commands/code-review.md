---
description: "Perform a code review for a PR, MR, or commit, including description, comments, and branch context"
allowed-tools: Bash(git:*), Bash(gh:*), Bash(glab:*), Read, Grep, Task, Skill, mcp__pragma__search, mcp__pragma__get_mr
---

# Task

You are a **code review coordinator** that runs parallel reviews using both **Claude code-reviewer agent** and **Gemini reviewer skill** for thorough multi-perspective analysis

**Input:** `$ARGUMENTS` — this can be:
- a **commit hash** (hex string)
- a **GitHub pull request number**
- a **GitLab merge request number**

**Instructions:**

1. Determine the type of input:
   - If numeric → treat as PR (GitHub) or MR (GitLab)
   - If hex string → treat as a commit hash

2. **Fetch the relevant code changes from GitLab/GitHub** (NOT from pragma):
   - For PR/MR → use `glab mr view` or `gh pr view` to get the metadata, then `glab mr diff` or `gh pr diff` to get the full diff
   - If the PR/MR is from a different branch than the current repository branch:
     - Conceptually, fetch and switch to the PR/MR branch before reviewing
     - Consider the code as it exists on that branch
   - For commit hash → identify the files changed in that commit via `git show`

3. **Inspect PR/MR metadata** (if applicable):
   - Read the **title** and **description** of the PR/MR
   - Read all **comments/discussions**
   - Use this information to understand the purpose, reasoning, and context of the changes

4. **Query pragma for historical context** (optional — skip gracefully if pragma MCP is unavailable):

   IMPORTANT: pragma is a separate historical database. It does NOT contain the MR you are currently reviewing.
   Use it ONLY to find similar past MRs for additional context. Never pass the current MR number to pragma.

   Make TWO parallel search calls — `query` and `code_diff` are mutually exclusive parameters:

   **Call A — Past decisions and discussions** (natural language):
   - Use `mcp__pragma__search` with:
     - `query`: a concise natural language description of the change's purpose, derived from the MR/PR title and description gathered in step 3 (e.g. "handle null values in user API response")
     - `content_type: "discussion"`
     - `top_k: 5`
   - This surfaces past team decisions, tradeoffs, and reviewer feedback on similar topics

   **Call B — Similar code patterns** (diff-based):
   - Use `mcp__pragma__search` with:
     - `code_diff`: the full unified diff obtained in step 2
     - `content_type: "diff"`
     - `top_k: 5`
   - This surfaces past implementations with structurally similar changes

   After both search calls complete:
   - For the top 2 results from either call with `similarity_score > 0.6`, call `mcp__pragma__get_mr` using the `mr_id` returned in the search results (never use the current MR's number)
   - Summarise the historical context: past decisions and rationale (from discussions), recurring code patterns and how similar changes were structured (from diffs), and any issues or regressions that followed similar past changes
   - If pragma is unavailable or returns an error on either call, continue without that source of context

5. **Review the code changes** in context of:
   - Correctness / logic errors
   - Code quality & maintainability
   - Security & input validation
   - Performance & efficiency
   - Test coverage and suggestions for missing tests
   - Read code comments in the modified files, and make sure the changes in the pull request comply with any guidance in the comments
   - Read the git blame and history of the code modified, to identify any bugs in light of that historical context

6. Apply project guidelines from CLAUDE.md and associated docs (if applicable):
   - `coding-guidelines.md`
   - `review-guidelines.md`
   - `security.md`

7. **Launch parallel reviews** in a SINGLE message with BOTH tool calls:
   - Task tool with subagent_type='code-reviewer' - passes all context from steps 1-6, including historical context from pragma (if available)
   - Skill tool with skill='gemini-reviewer' - passes same context
   - CRITICAL: Both must be launched in the same message for true parallelism

8. **Wait for both reviews to complete**

9. For each issue found by either reviewer, launch a parallel validation agent that takes the PR and issue description, and returns a score to indicate the agent's level of confidence for whether the issue is real or false positive. To do that, the agent should score each issue on a scale from 0-100

10. Filter out any issues with a score less than 30. If there are no issues that meet this criteria, do not proceed.

11. **Output combined review** in a structured format:

**Format Example:**

## Historical Context (Pragma MCP)
[If pragma was available, two subsections:]

### Similar Past Discussions
[Top relevant MRs found via discussion search: IDs, titles, scores, and key decisions or tradeoffs the team made]

### Similar Past Code Changes
[Top relevant MRs found via diff search: IDs, titles, scores, and how similar patterns were implemented or reviewed]

[Omit this entire section if pragma was unavailable.]

---

## Claude Code Reviewer
[Complete output from Claude's code-reviewer agent]

---

## Gemini Reviewer
[Complete output from Gemini reviewer skill]

---

## Combined Analysis
- **Summary:** Synthesized overview from both reviewers
- **Critical Issues:** Unique critical issues from both reviewers (after filtering by confidence score)
- **Common Findings:** Issues identified by both reviewers (higher confidence)
- **Moderate/Minor Issues:** Lower priority improvements from both reviewers
- **Unique Insights:** Issues found by only one reviewer
- **Recommendations:** Synthesized recommendations from both perspectives

**Notes:**
- The MR/PR being reviewed lives in GitLab/GitHub — always fetch it using `glab`/`gh` CLI tools, never from pragma
- pragma is a historical database of past MRs; only use it to find context, never to fetch the current MR
- Only call `mcp__pragma__get_mr` with IDs returned by a prior `mcp__pragma__search` call
- Launch both reviewers in parallel in a SINGLE message (not sequentially)
- The two pragma calls (discussion and diff) are independent and should also run in parallel
- Do not hallucinate files or code not present in the repository or the PR/MR branch
- Focus on changed files only
- Be concise but precise
- When discussing issues, reference the relevant lines/files clearly
- Include insights from discussions/comments if they affect code correctness, design, or testing
- Treat the PR/MR branch as the source of truth when reviewing code
- Compare findings from both reviewers and highlight agreements and unique insights
- Synthesize recommendations that incorporate both perspectives
- If pragma historical context is available, highlight when a current finding echoes a past issue or contradicts a past team decision
