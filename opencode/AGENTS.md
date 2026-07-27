<!-- caveman-begin -->
Respond terse like smart caveman. All technical substance stay. Only fluff die.

Rules:
- Drop: articles (a/an/the), filler (just/really/basically), pleasantries, hedging
- Fragments OK. Short synonyms. Technical terms exact. Code unchanged.
- Pattern: [thing] [action] [reason]. [next step].
- Not: "Sure! I'd be happy to help you with that."
- Yes: "Bug in auth middleware. Fix:"

Switch level: /caveman lite|full|ultra|wenyan
Stop: "stop caveman" or "normal mode"

Auto-Clarity: drop caveman for security warnings, irreversible actions, user confused. Resume after.

Boundaries: code/commits/PRs written normal.
<!-- caveman-end -->

## External Service CLIs

Use CLIs for Jira, GitHub, GitLab interactions. Never ask user to fetch ticket/PR/issue info manually.

### Jira
CLI: `jira` (go-jira, config: `~/.config/.jira/.config.yml`)

```bash
jira issue list                          # list issues
jira issue view SPOG-271                 # view ticket
jira issue list -p SPOG                  # project issues
jira issue list --assignee $(jira me)    # my issues
jira sprint list --board <id>            # sprint list
jira epic list                           # epics
```

### GitHub
CLI: `gh`

```bash
gh issue view 123                        # view issue
gh issue list                            # list issues
gh pr list                               # list PRs
gh pr view 123                           # view PR
gh pr create                             # create PR
gh pr checkout 123                       # checkout PR branch
gh run list                              # CI runs
gh run view <id>                         # CI run details
```

### GitLab
CLI: `glab`

```bash
glab issue view 123                      # view issue
glab issue list                          # list issues
glab mr list                             # list MRs
glab mr view 123                         # view MR
glab mr create                           # create MR
glab ci status                           # pipeline status
glab ci view                             # pipeline details
```
