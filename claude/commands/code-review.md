---
description: "Perform a code review for a PR, MR, or commit, including description, comments, and branch context"
allowed-tools: Bash(git:*), Bash(gh:*), Bash(glab:*), Read, Grep, Task, Skill
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
   - Read code comments in the modified files, and make sure the changes in the pull request comply with any guidance in the comments
   - Read the git blame and history of the code modified, to identify any bugs in light of that historical context

5. Apply project guidelines from CLAUDE.md and associated docs (if applicable):
   - `coding-guidelines.md`
   - `review-guidelines.md`
   - `security.md`

6. **Launch parallel reviews** in a SINGLE message with BOTH tool calls:
   - Task tool with subagent_type='code-reviewer' - passes all context from steps 1-5
   - Skill tool with skill='gemini-reviewer' - passes same context
   - CRITICAL: Both must be launched in the same message for true parallelism

7. **Wait for both reviews to complete**

8. For each issue found by either reviewer, launch a parallel validation agent that takes the PR and issue description, and returns a score to indicate the agent's level of confidence for whether the issue is real or false positive. To do that, the agent should score each issue on a scale from 0-100

9. Filter out any issues with a score less than 30. If there are no issues that meet this criteria, do not proceed.

10. **Output combined review** in a structured format:

**Format Example:**

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
- Launch both reviewers in parallel in a SINGLE message (not sequentially)
- Do not hallucinate files or code not present in the repository or the PR/MR branch
- Focus on changed files only
- Be concise but precise
- When discussing issues, reference the relevant lines/files clearly
- Include insights from discussions/comments if they affect code correctness, design, or testing
- Treat the PR/MR branch as the source of truth when reviewing code
- Compare findings from both reviewers and highlight agreements and unique insights
- Synthesize recommendations that incorporate both perspectives
