---
description: "Fetch and analyse Pragma's AI review for a GitLab MR. Summarises high-value findings and critiques the review quality. Usage: /pragma-review [mr_number]"
allowed-tools: Bash(glab:*), mcp__pragma__list_reviews, mcp__pragma__get_review
---

# Pragma Review

Fetch and analyse Pragma's AI-generated review for a GitLab MR.

**Input:** `$ARGUMENTS` — optional MR number (integer). If omitted, detected from context.

## Instructions

1. **Determine the MR number:**
   - If `$ARGUMENTS` contains an integer, use it directly as the MR number.
   - Otherwise, run `glab mr view` and parse the `IID:` field from the output.
   - If both fail, ask the user: "Which MR number would you like to review?"

2. **Determine the repository name:**
   - Run `glab mr view` (or reuse output from step 1) and parse the `Project:` or
     `Web URL` field to extract the repository name (e.g. `pdm-db`).
   - Use just the short repository name (last path segment), not the full group path.

3. **Find the most recent Pragma review for this MR:**
   - Call `mcp__pragma__list_reviews` with `repository` set to the repo name from step 2.
   - Filter returned entries where the filename contains `_mr<MR_NUMBER>_`.
   - If multiple matches exist, select the one with the latest timestamp (the timestamp
     appears in the filename as `YYYYMMDD_HHMMSS`).
   - If no matching review is found, output:
     > "No Pragma review found for MR !<number> in repository <repo>."
     and stop.

4. **Fetch the full review content:**
   - Call `mcp__pragma__get_review` with the filename selected in step 3.

5. **Output Section B — High-value findings:**

   Present a prioritised list of findings from the Pragma review that meet ALL of:
   - Blocking, critical, or high-severity (explicitly stated in Pragma's output, or
     clearly impactful based on context)
   - Non-obvious (not something a linter, type-checker, or compiler would catch)
   - Actionable (has a specific file/line reference or a concrete recommendation)

   Format:
   ```
   ## High-Value Findings (Pragma MR !<number>)

   1. [CRITICAL/HIGH] <finding summary> — `<file>:<line>`
      Rationale: <one sentence on why this is worth acting on>

   2. ...
   ```

   If no findings meet the criteria, state: "No high-value findings identified."

6. **Output Section C — Meta-critique:**

   Assess the quality of the Pragma review itself across four dimensions:

   ```
   ## Pragma Review Quality Assessment

   **Coverage:** <Did it address the key areas of the diff? What did it focus on?>
   **Accuracy:** <Are the findings grounded in the actual code? Any hallucinations?>
   **False positives:** <List any findings that appear incorrect or unsubstantiated>
   **Gaps:** <Important aspects of the diff that Pragma missed entirely>
   ```

## Notes

- Be concise. Section B should rarely exceed 5 items.
- Section C should be factual, not speculative — only flag gaps you can identify from
  the diff or codebase context.
- Do not repeat the full Pragma review verbatim.
