---
description: "Scan a public repository for sensitive or internal information before pushing. Checks staged changes and all tracked files for internal hostnames, usernames, repo paths, API keys, local paths, and internal IDs."
allowed-tools: Bash(git remote get-url *), Bash(git log *), Bash(git diff *), Bash(git ls-files *), Bash(whoami), Grep, Read
---

# Public Repository Safety Check

**CRITICAL:** This check must be run before every push to a public repository. Never skip it.

## Instructions

You are performing a pre-push safety scan to ensure no sensitive or internal information is about to be published.

### Step 1 — Confirm this is a public repository

Check the remote URL:

```bash
git remote get-url origin
```

- If the URL contains `github.com` or any other clearly public host → proceed with the full check.
- If the URL is an internal/corporate host and the user confirms it is private → inform the user the check is not required, but offer to run it anyway.

### Step 2 — Identify what is about to be pushed

Get the list of tracked files and any commits not yet on the remote:

```bash
git log origin/HEAD..HEAD --oneline 2>/dev/null || git log --oneline -10
git diff origin/HEAD..HEAD --stat 2>/dev/null || git diff --cached --stat
git ls-files
```

### Step 3 — Scan tracked files using the Grep tool

Use the **Grep tool** (not Bash) for all content searches. The Grep tool returns matches with file name and line number. No output from a Grep call means no matches — treat that as clean, not as an error.

Run all six scans. Report **every match** found.

**3a. Internal hostnames and domains**

Use Grep with this pattern across `.` (project root):
- Pattern: `(?i)\.(internal|corp|company|lan)\b|gitlab\.cee\.|\.redhat\.com`

**3b. Real username**

First get the username:
```bash
whoami
```
Then use Grep with the returned username as the literal pattern across `.`.

**3c. Absolute local paths**

Use Grep with pattern `/home/<username>|/Users/<username>` (substituting the real username) across `.`.

**3d. API keys, tokens, and secrets**

Use Grep with this pattern across `.`:
- Pattern: `(?i)(api[_-]?key|secret|password|private[_-]?token)\s*[:=]\s*['"]?[A-Za-z0-9+/]{10,}`

**3e. Hard-coded internal ticket or MR IDs used as examples**

Use Grep with this pattern across `.`:
- Pattern: `(?i)(PDM-|JIRA-|MR !)[0-9]{3,}`

**3f. Scan the diff for internal organisation names**

Get the diff:
```bash
git diff origin/HEAD..HEAD 2>/dev/null || git diff --cached
```
Then use Grep on the diff output for any added lines (`^\+`) containing internal org or group names that were discovered during the session.

### Step 4 — Report findings

**If no matches from any scan (empty results or no output):**
> Safety check passed. No sensitive or internal information detected. Safe to proceed.

**If any matches found:**

List each finding:
```
FINDING: <type>
File:    <file>:<line>
Content: <the offending line>
Fix:     <suggested replacement>
```

Then **stop**. Do NOT proceed with the push until the user confirms all findings have been resolved.

### Step 5 — Offer to fix

For each finding, offer to apply the fix automatically using the Edit tool. Wait for user approval before making any change.

Common replacements:
- Internal hostname → `gitlab.example.com`
- Real username → `your-username`
- Internal org/group paths → `my-group/my-repo`
- Hard-coded IDs used as examples → `42`
- Absolute local paths → relative path or `<path-to-project>`

### Step 6 — Re-scan after fixes

After applying fixes, re-run the relevant Grep scans from Step 3 to confirm all issues are resolved before allowing the push.
