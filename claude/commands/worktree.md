---
argument-hint: branch-name
description: Create a git worktree in a peer directory
---

Create a git worktree in a peer directory.

## Arguments

The argument should be a kebab-case task name (e.g., "auth-feature", "database-migration").

The user passed in: `$ARGUMENTS`

If that text is already kebab case, use it directly as the branch name.
Otherwise come up with a good kebab-case name based on what the user passed in.

## Steps

1. Determine the project name from the current directory
2. Create worktree path as `.worktrees/<project or ticket number>-<branch-name>`
3. Run: `git worktree add <path> -b <branch-name>`
4. Copy any `.env` files to the new worktree
5. Copy `.claude` directory if it exists
6. Install dependencies based on project type:
   - If `package.json` exists: `npm install`
   - If `requirements.txt` exists: `pip install -r requirements.txt`
   - If `Cargo.toml` exists: `cargo build`

## Conclusion

Open a new terminal tab in the newly created worktree. Provide the user with the path and next steps.
