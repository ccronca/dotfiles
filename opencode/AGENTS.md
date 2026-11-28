## Writing Voice and Personality

When drafting any user-facing text — MR/PR descriptions, Jira ticket descriptions, code review comments, Slack messages, commit body text — apply this voice:

* **Tone:** Casual and direct. Not stiff or corporate.
* **Sentences:** Short. One idea per sentence. No run-ons.
* **Vocabulary:** Simple, everyday words. B1/B2 level. Avoid idioms, jargon, and fancy synonyms.
* **Structure:** Bullet points over paragraphs. State the point first, then explain if needed.
* **No filler:** Skip phrases like "it is worth noting that", "as mentioned above", "in order to". Just say the thing.
* **Words to avoid:** leverage, utilize, facilitate, comprehensive, robust, streamline, granular, holistic.
* **Style examples:**
  - "This facilitates a more granular control of the deployment pipeline" → "This gives us more control over deployments."
  - "It is worth noting that the current implementation does not handle edge cases" → "This does not handle edge cases yet."

This voice applies to ALL written output that represents the user: comments, tickets, MRs, reviews, messages. It does NOT apply to code, technical docs inside the repo, or commit subject lines (those follow the Conventional Commits format).

---

## External Service CLIs

Use CLIs for Jira, GitHub, GitLab interactions. Never ask user to fetch ticket/PR/issue info manually.

### Jira
CLI: `jira` (go-jira, config: `~/.config/.jira/.config.yml`)

```bash
jira issue list                          # list issues
jira issue view PROJ-123                 # view ticket
jira issue list -p PROJ                  # project issues
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

### GitLab MR comment mechanics (glab api)

- Anchored review comment: `POST projects/<id>/merge_requests/<iid>/discussions`
  with a JSON body: `{"body": "...", "position": {position_type: "text", base_sha,
  start_sha, head_sha, old_path, new_path, new_line}}`. Get the shas from the MR's
  `diff_refs`. Verify the returned note has `type: "DiffNote"`.
- Gotchas on gitlab.cee.redhat.com: form-field position keys (`-f position_type=...`)
  and the `/notes` endpoint both silently drop the position — you get an unanchored
  general comment. JSON body on `/discussions` is the only shape that anchors.
- Reply in a thread: `POST .../discussions/<discussion_id>/notes -f body="..."`.
  (`/comments` 404s.)
- Reopen a resolved thread: `PUT .../discussions/<discussion_id>?resolved=false`.
- Delete a stray note: `DELETE .../notes/<note_id>`.

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->
