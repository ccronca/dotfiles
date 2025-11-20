# CLAUDE.md Guidelines

This document outlines the best practices and mandatory rules to follow when generating documentation, code, commit messages, Pull Requests (PRs), and Merge Requests (MRs) with AI assistance.

---

## General Language and Tone

* **Language Level:** Write in clear, precise **B2-level English**.
* **Tone:** Maintain a clear and **professional** tone.
* **Vocabulary Restriction:** **Do not use the word "comprehensive."**
* **Emojis:** **Do not use emojis** in any formal documentation or requests.

---

## Pull Request (PR) and Merge Request (MR) Guidelines

Merge Requests (MRs) must follow the same principles and best practices used for creating a Pull Request (PR).

### I. Description Structure and Content

The PR/MR description **must** be clear, professional, and **structured with bullet points**.

* **Reviewer Context:** Assume the reviewers are familiar with the project and **do not require extensive background** on the overall architecture.
* **Mandatory Sections:** The description must include:
    * **Summary:** A brief explanation of the change.
    * **Motivation:** Why the change is needed.
    * **Overview of changes:** Focus only on the **design points**, not the full commits. Summarize the overall impact and architectural or design-level changes. **Do not** include details of individual commits or all modified files.
    * **Testing steps (Optional):** How to verify the change. **Only include this if it is strictly necessary** and not covered by other testing (e.g., unit tests).

### II. Attribution and Workflow

* **AI Acknowledgment:** In every MR/PR description, please include a brief, clear acknowledgment of your role (as an AI model) in generating the summary and text. This should be a concise statement, perhaps at the end, confirming that the description was AI-assisted.
* **New Feature Branching:**
    * **Do not modify the `main` or default branch** when developing a new feature.
    * Propose a **well-formatted, descriptive branch name** adhering to common conventions (e.g., starting with `feature/`).
    * Create the branch and switch to this new branch before development.

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

* **Format:** Make them **concise**, use the **imperative mood** ("add" not "added"), **start with a capital letter**, and **avoid punctuation at the end**.
* **Content:** Clearly describe **what and why** the change was made.
* **Length:**
  * Keep subject line **under 72 characters**.
  * Wrap body text at **80 characters per line**.
  * Use a **blank line between subject and body**.
* **Footer:** Use footer for references (e.g., issue numbers) or breaking changes.
* **Attribution:** **Include Claude attribution** within the commit message.
* **Sign-off:** **Always include the `Signed-off-by` line**. Use the `--signoff` flag when creating commits with `git`.
* Focus on summarizing the **high-level purpose and impact of the changes** rather than listing individual file edits or small details.

---

## Code Generation Guidelines

* **Comments:** Include comments **only if they add meaningful context**. Avoid adding comments that do not clarify the code.
* **Purpose:** Add comments especially when something is **ambiguous, involves a design decision, or requires explanation** for readability and maintainability.
* **Agent Usage:**
  * When working with dbt models, always use the dbt-data-engineer agent
  * For code reviews, always use the code-reviewer agent to ensure quality, security, and maintainability checks

---

## Work-Specific Guidelines

For work-specific or project-specific configuration, see:

@~/.claude/CLAUDE.local.md
