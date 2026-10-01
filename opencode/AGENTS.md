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

<!-- codebase-memory-mcp:start -->
# Codebase Knowledge Graph (codebase-memory-mcp)

This project uses codebase-memory-mcp to maintain a knowledge graph of the codebase.
ALWAYS prefer MCP graph tools over grep/glob/file-search for code discovery.

## Priority Order
1. `search_graph` — find functions, classes, routes, variables by pattern
2. `trace_path` — trace who calls a function or what it calls
3. `get_code_snippet` — read specific function/class source code
4. `query_graph` — run Cypher queries for complex patterns
5. `get_architecture` — high-level project summary

## When to fall back to grep/glob
- Searching for string literals, error messages, config values
- Searching non-code files (Dockerfiles, shell scripts, configs)
- When MCP tools return insufficient results

## Examples
- Find a handler: `search_graph(name_pattern=".*OrderHandler.*")`
- Who calls it: `trace_path(function_name="OrderHandler", direction="inbound")`
- Read source: `get_code_snippet(qualified_name="pkg/orders.OrderHandler")`
<!-- codebase-memory-mcp:end -->

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->
