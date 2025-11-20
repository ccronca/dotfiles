---
description: "Perform a code review for a PR, MR, or commit, including description, comments, and branch context"
allowed-tools: Bash(git:*), Bash(gh:*), Bash(glab:*), Read, Grep
---

# Task

You are a **code review agent** perform a comprehensive review using
the **code-reviewer** agent

**Input:** `$ARGUMENTS` — this can be:
- a **commit hash** (hex string)
- a **GitHub pull request number**
- a **GitLab merge request number**

**Instructions:**

1. Determine the type of input:
   - If numeric → treat as PR (GitHub) or MR (GitLab)
   - If hex string → treat as a commit hash

2. **Fetch the relevant code changes:**
   - For PR/MR → identify which files were added, modified, or deleted
   - If the PR/MR is from a different branch than the current repository branch:
     - Conceptually, fetch and switch to the PR/MR branch before reviewing
     - Consider the code as it exists on that branch
   - For commit hash → identify the files changed in that commit

3. **Inspect PR/MR metadata** (if applicable):
   - Read the **title** and **description** of the PR/MR
   - Read all **comments/discussions**
   - Use this information to understand the purpose, reasoning, and context of the changes

4. **Review the code changes** in context of:
   - Correctness / logic errors
   - Code quality & maintainability
   - Security & input validation
   - Performance & efficiency
   - Test coverage and suggestions for missing tests

5. Apply project guidelines from CLAUDE.md and associated docs (if applicable):
   - `coding-guidelines.md`
   - `review-guidelines.md`
   - `security.md`

6. **Output your review** in a structured format:

**Format Example:**
- **Summary:** High-level overview of issues and quality, including context from PR/MR description and comments
- **Critical Issues:** List of major problems, with suggested fixes/code snippets
- **Moderate/Minor Issues:** Optional improvements
- **Context Notes:** Key insights from PR/MR description and comments
- **Branch Notes:** Indicate which branch the review is based on
- **Recommendations:** Additional refactorings or tests

**Notes:**
- Do not hallucinate files or code not present in the repository or the PR/MR branch
- Focus on changed files only
- Be concise but precise
- When discussing issues, reference the relevant lines/files clearly
- Include insights from discussions/comments if they affect code correctness, design, or testing
- Treat the PR/MR branch as the source of truth when reviewing code
