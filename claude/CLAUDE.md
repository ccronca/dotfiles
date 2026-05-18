# CLAUDE.md Guidelines

This document outlines the best practices and mandatory rules to follow when generating documentation, code, commit messages, Pull Requests (PRs), and Merge Requests (MRs) with AI assistance.

---

## General Language and Tone

* **Language Level:** Write in clear, precise **B2-level English**.
* **Tone:** Maintain a clear and **professional** tone.
* **Vocabulary Restriction:** **Do not use the word "comprehensive."**
* **Emojis:** **Do not use emojis** in any formal documentation or requests.

---

## Prompt Rewriting Hook Response Format

**IMPORTANT:** When the user triggers the prompt rewriting hook (using `#rw` prefix):

* **Always acknowledge the rewrite** at the start of your response
* **Show both versions:** Display the original and improved prompts
* **Highlight key improvements:** Briefly explain what changed and why
* **Then proceed** with answering the improved prompt

**Format to use:**

```
📝 Your original prompt:
"[original text]"

✨ Improved version:
"[improved text]"

Key improvements:
- [improvement 1]
- [improvement 2]
- [improvement 3]

[Then continue with the actual answer to the improved prompt]
```

**Purpose:** This helps the user learn English by seeing concrete examples of grammatical corrections and clarity improvements.

---

## Claude Code Settings and Documentation

**IMPORTANT:** When working with Claude Code configuration or features:

* **Always use the claude-docs skill** to verify syntax, patterns, and configuration before making changes
* **Check official documentation** for permission patterns, auto-approval syntax, hooks, and other settings
* **Do NOT guess** at configuration syntax - fetch the relevant documentation first

Examples of when to use claude-docs skill:
* Modifying `settings.json` (permissions, auto-approval patterns, hooks)
* Creating or updating hooks
* Working with slash commands
* Configuring MCP servers
* Understanding tool-specific permission rules

---

## Description Guidelines for Commits and Pull Requests

**IMPORTANT:** Both commit messages and PR/MR descriptions should be concise summaries, not detailed changelogs.

### What NOT to Include

Do NOT include in commit messages or PR/MR descriptions:

* **Test results** - No mentions of "tests passed", "all tests passing", "CI pipeline green"
* **Specific test details** - No descriptions of individual test implementations or test names
* **Exhaustive lists** - No listing every single file, commit, or line changed
* **Implementation minutiae** - No low-level technical details of how something was implemented
* **Obvious information** - No describing what git already tracks (file lists, diffs)

### What TO Include

DO include in both commit messages and PR/MR descriptions:

* **High-level summary** - What changed at a conceptual level
* **Motivation** - Why the change was necessary
* **Impact** - What benefit or problem solved
* **Design decisions** - Architectural or design-level choices (for PRs/MRs)

---

## Pull Request (PR) and Merge Request (MR) Guidelines

Merge Requests (MRs) must follow the same principles and best practices used for creating a Pull Request (PR).

### I. Description Structure and Content

The PR/MR description **must** be clear, professional, and **structured with bullet points**.

* **Reviewer Context:** Assume the reviewers are familiar with the project and **do not require extensive background** on the overall architecture.
* **Follow Description Guidelines:** See @"Description Guidelines for Commits and Pull Requests" section above for what to include and exclude.
* **Mandatory Sections:** The description must include:
    * **Summary:** A brief explanation of the change.
    * **Motivation:** Why the change is needed.
* **Optional Sections:**
    * **Overview of changes:** **Only include this section if it provides meaningful design or architectural insights** that are not obvious from reading the code diff. Do NOT include if it would just summarize what the code already shows. Focus on design decisions, architectural patterns, or non-obvious implications when included.
    * **Testing steps:** How to verify the change. **Only include this if it is strictly necessary** and not covered by other testing (e.g., unit tests).

### II. Attribution and Workflow

* **AI Acknowledgment:** In every MR/PR description, please include a brief, clear acknowledgment of your role (as an AI model) in generating the summary and text. This should be a concise statement, perhaps at the end, confirming that the description was AI-assisted.
* **New Feature Branching:**
    * **Do not modify the `main` or default branch** when developing a new feature.
    * Propose a **well-formatted, descriptive branch name** adhering to common conventions (e.g., starting with `feature/`).
    * Create the branch and switch to this new branch before development.
* **Automatic Code Review:**
    * After successfully creating a PR/MR, automatically launch the code-reviewer agent to review the changes.
    * Use the Task tool with `subagent_type='code-reviewer'`.
    * Provide the PR/MR number or branch name for context.
    * Present the review findings to the user for consideration.

---

## Commit Message Guidelines

All commit messages must be clear, concise, and follow established best practices.

Reference: [See how a minor change to your commit message style can make you a better programmer](https://www.conventionalcommits.org/)

### Conventional Commits Format

Use the following format: `<type>(<scope>): <subject>`

**Types:**
* `feat`: New feature for the user (not a new feature for build script)
* `fix`: Bug fix for the user (not a fix to a build script)
* `docs`: Changes to the documentation
* `style`: Formatting, missing semi colons, etc. (no production code change)
* `refactor`: Refactoring production code (e.g., renaming a variable)
* `test`: Adding missing tests, refactoring tests (no production code change)
* `chore`: Updating grunt tasks, etc. (no production code change)

**Scope:** Optional, specifies the area of the codebase affected (e.g., `api`, `auth`, `ui`)

**Examples:**
* `feat(auth): Add OAuth2 authentication`
* `fix(api): Handle null values in user response`
* `docs: Update installation instructions`
* `refactor(database): Rename getUserById to fetchUser`

### Additional Requirements

* **Follow Description Guidelines:** See @"Description Guidelines for Commits and Pull Requests" section above for what to include and exclude.
* **Format:** Make them **concise**, use the **imperative mood** ("add" not "added"), **start with a capital letter**, and **avoid punctuation at the end**.
* **Content:** Clearly describe **what and why** the change was made.
* **Length:**
  * Keep subject line **under 72 characters**.
  * Wrap body text at **80 characters per line**.
  * Use a **blank line between subject and body**.
* **Footer:** Use footer for references (e.g., issue numbers) or breaking changes.
* **Attribution:** **Include Claude attribution** within the commit message.
* **Sign-off:** **Always include the `Signed-off-by` line**. Use the `--signoff` flag when creating commits with `git`.

### Commit Message Examples

**BAD - Too detailed:**
```
fix(api): Fix null handling in user endpoint

- Modified src/api/users.py line 45 to add null check
- Updated src/models/user.py line 23 to handle None values
- Added test_user_null_handling in tests/test_api.py
- Added test_user_response_validation in tests/test_api.py
- All 47 tests passing
```

**GOOD - Concise summary:**
```
fix(api): Handle null values in user response

Prevent crashes when user data contains null fields by adding
validation before processing.
```

---

## Documentation and Design Plans Guidelines

### Design Documents and Plans

**IMPORTANT**: Do NOT commit design documents or plans to git unless explicitly requested by the user.

**Files that should NOT be auto-committed:**
* Design documents in `docs/plans/` directory
* Brainstorming outputs and exploratory documents
* Analysis reports and investigation documents
* Draft documentation

**Reason**: These are working documents that require human review and approval before being added to version control. The user will review and commit manually if they want to preserve them.

**Files that CAN be committed** (when part of a feature/fix):
* Code changes (scripts, models, source files, etc.)
* Bug fixes and feature implementations
* Test files

**Files that CAN be committed when explicitly requested:**
* ADRs (Architecture Decision Records) in `docs/ADR/`
* README updates
* API documentation updates

**Workflow:**
1. Create design documents as requested
2. Present them to the user for review
3. Wait for explicit instruction before committing
4. Only commit if user approves and requests it

---

## Code Generation Guidelines

* **Comments:** Include comments **only if they add meaningful context**. Avoid adding comments that do not clarify the code.
* **Purpose:** Add comments especially when something is **ambiguous, involves a design decision, or requires explanation** for readability and maintainability.
* **Agent and Skill Usage:**
  * When working with dbt models, always use the dbt-data-engineer agent
  * For code reviews, always use the code-reviewer agent to ensure quality, security, and maintainability checks
  * **When working with Containerfiles or Kubernetes manifests, always use the container-k8s-validator skill** to validate path consistency and completeness

### General Coding Best Practices

**IMPORTANT:** Apply these principles to all code, regardless of language.

**1. DRY (Don't Repeat Yourself)**
* Never duplicate code - if the same logic appears in multiple places, extract it into a shared function or module
* Refactor immediately when you notice duplication
* Each piece of knowledge should have one authoritative representation

**2. KISS (Keep It Simple, Stupid)**
* Prefer simple, clear solutions over clever or complex ones
* Avoid over-engineering - only add complexity when truly needed
* If something can be done in 5 lines instead of 50, choose the simpler approach

**3. YAGNI (You Aren't Gonna Need It)**
* Don't add functionality until it's actually needed
* Avoid building for hypothetical future requirements
* Focus on solving the current problem

**4. Separation of Concerns**
* Each function/module should have a single, well-defined responsibility
* Keep business logic separate from presentation logic
* Database access, API calls, and data processing should be in separate layers

**5. Meaningful Names**
* Use descriptive variable, function, and file names
* Names should reveal intent - avoid abbreviations unless universally understood
* Functions should be verbs, variables should be nouns

**6. Fail Fast**
* Validate inputs early and return/throw errors immediately
* Don't let invalid data propagate through the system
* Use guard clauses to handle edge cases upfront

**7. Consistency**
* Follow existing patterns and conventions in the codebase
* If the project uses a certain style or structure, maintain it
* Don't mix different approaches to solving the same problem

### Python: Always Follow the Pythonic Way

When writing or modifying Python code, use Pythonic patterns:

- **Patterns:** for-else instead of flags; context managers (`with`); list/dict comprehensions; truthiness checks (`if items:` not `if len(items) > 0:`); `is`/`is not` for None; `enumerate()`; `zip()`; `dict.get()` with defaults; f-strings; type hints
- **Quality:** null safety before attribute access; prefer `any()`/`all()`/`sum()` over manual loops; generators for large datasets; use `@lru_cache`/`@cache` for memoization
- **Linting:** run `python3 -m flake8` (or available linter) after writing Python; fix F401 (unused imports), E722 (bare except — always specify exception type), missing `encoding='utf-8'` in file opens; E501 line-length is a soft rule — ignore for URLs and long strings
- **Comments:** explain *why*, not *what*; avoid comments that merely restate the code

**References:** [PEP 8](https://peps.python.org/pep-0008/), [PEP 20](https://peps.python.org/pep-0020/)

### Bash: Error Handling and Script Safety

**IMPORTANT:** When writing or modifying Bash scripts, always include strict error handling at the beginning of the script.

**Mandatory Error Handling:**

Every Bash script must start with:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

**What each flag does:**

* `set -e`: Exit immediately if any command exits with a non-zero status (fail fast)
* `set -u`: Treat unset variables as an error and exit immediately
* `set -o pipefail`: Return the exit status of the last command in a pipeline that failed (not just the last command)

**Why this matters:**

* **Prevents silent failures:** Without these flags, scripts can continue running after errors, leading to data corruption or incorrect state
* **Catches typos:** Unset variables will cause immediate failure instead of being treated as empty strings
* **Pipeline safety:** Ensures errors in the middle of a pipeline are not ignored

**Debug Mode:**

For debugging purposes, you can temporarily add the `-x` flag:

```bash
#!/usr/bin/env bash
set -euxo pipefail  # Added -x for debugging
```

**CRITICAL WARNING about debug mode:**
* **NEVER leave `set -x` enabled in production scripts**
* The `-x` flag prints every command before execution, which **can leak sensitive data** such as:
  * Passwords and API keys passed as variables
  * Database connection strings
  * Authentication tokens
  * Private file contents
* **Only use `set -x` during development/debugging**
* **Always remove it before committing to production**

**Example:**

```bash
#!/usr/bin/env bash
set -euo pipefail

# Script will exit immediately if:
# - Any command fails (set -e)
# - An undefined variable is used (set -u)
# - Any command in a pipeline fails (set -o pipefail)

DATABASE_URL="${DATABASE_URL}"  # Will fail if not set (set -u)
psql "${DATABASE_URL}" < schema.sql  # Will fail if psql fails (set -e)
```

**Exceptions:**

If you need to handle errors explicitly in specific cases, you can temporarily disable error handling:

```bash
set -euo pipefail

# Temporarily allow a command to fail
set +e
some_command_that_might_fail
exit_code=$?
set -e

if [ $exit_code -ne 0 ]; then
    echo "Command failed as expected"
fi
```

---

## Python Virtual Environment Guidelines

When executing Python commands (e.g., running tests, installing packages, executing scripts), follow these rules:

### Detect Package Manager First

**IMPORTANT:** Before running any Python command, detect which package manager the project uses:

1. **Check for `uv` usage** (priority check):
   - Look for `uv.lock` file in the project root
   - Or check if `pyproject.toml` exists with uv-specific configuration
   - If found: **Use `uv` for all package operations**

2. **Otherwise, use standard venv/pip**

### Using `uv` for Package Management

**If the project uses `uv` (has `uv.lock` file):**

**Installing packages:**
```bash
uv add package-name
```

**Running commands:**
```bash
uv run pytest tests/
uv run python script.py
```

**Syncing dependencies:**
```bash
uv sync
```

**DO NOT use `pip install` or `source .venv/bin/activate` in `uv` projects** - `uv` manages the virtual environment automatically.

### Automatic Virtual Environment Detection (for non-uv projects)

1. **Before running any Python command**, check if a `.venv` directory exists in the current project directory
2. **If `.venv` exists:**
   - Prefix the command with `source .venv/bin/activate &&`
   - Example: `source .venv/bin/activate && pytest tests/`
3. **If `.venv` does not exist:**
   - Inform the user that no virtual environment was found
   - Offer to create one by running `/setup-venv` command
   - Wait for user approval before creating the venv

### Creating Virtual Environments

* Use the `/setup-venv` command to create and configure virtual environments
* Virtual environments are created in `.venv` directory (already in `.gitignore`)
* The setup command automatically:
  * Creates the virtual environment
  * Upgrades pip
  * Installs dependencies from `requirements.txt`, `pyproject.toml`, or `setup.py`

### Examples

**For `uv` projects (has `uv.lock`):**
```bash
# Installing packages
uv add requests

# Running tests
uv run pytest tests/

# Running scripts
uv run python script.py
```

**For standard venv projects (no `uv.lock`):**
```bash
# Running tests
source .venv/bin/activate && pytest tests/

# Installing packages
source .venv/bin/activate && pip install requests

# Running scripts
source .venv/bin/activate && python script.py
```

---

## Public Repository Safety

> **CRITICAL — Run `/public-repo-check` before every push to a public repository.**
> This check is mandatory and non-negotiable. Do not skip it.

Before pushing to any public repository (GitHub or other public host), always invoke the `/public-repo-check` skill. It scans staged and tracked files for sensitive or internal information that must never be exposed publicly.

### What the check covers

* **Internal hostnames** — corporate GitLab instances, internal domains
* **Real usernames or email addresses** — your own or colleagues'
* **Internal repository paths** — organisation/group names used as hard-coded values or examples
* **API keys, tokens, or passwords** — even in comments, docstrings, or example configs
* **Local machine paths** — absolute paths like `/home/username/...`
* **Internal IDs** — ticket numbers or specific MR/PR IDs hard-coded as examples

### How to fix findings

* Replace internal hostnames → `gitlab.example.com`
* Replace real usernames → `your-username` or `<your-name>`
* Replace internal repo paths → `my-group/my-repo`
* Replace hard-coded IDs → small round numbers like `42`
* Replace local absolute paths → `<path-to-project>` or relative paths

---

## Work-Specific Guidelines

For work-specific or project-specific configuration, see:

@~/.claude/CLAUDE.local.md

---

## Codebase Memory (codebase-memory-mcp)

When this MCP server is available, **prefer graph tools over grep/Explore for structural code questions**.
Graph queries return precise results in a single tool call (~500 tokens) vs file-by-file exploration (~80K tokens).

Use grep/Glob for text search (string literals, error messages, config values) - the graph doesn't index text content.
For detailed tool reference, decision matrix, and usage patterns, invoke the `codebase-memory` skill.

