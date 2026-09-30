# AGENTS.md -- {{PROJECT_NAME}}

{{DESCRIPTION}}

## Build and test

```bash
{{BUILD_COMMAND}}
{{TEST_COMMAND}}
{{LINT_COMMAND}}
```

## Plan

`TASKS.md` is the plan and the source of truth for progress. Work the
current phase in order, mark tasks done as they finish, and add newly
found work to the current phase.

## Rules

- Work on a feature branch. One logical change per commit.
- Do not push, force-push, or delete branches unless asked.
- Do not commit secrets or `.env*` files.
- Do not add dependencies or edit CI workflows without approval.
- Run build, tests and lint before calling a task done.

## Growing this setup

Start small. Add each piece in the commit that first needs it:

| When this happens | Add |
|---|---|
| A convention is repeated or corrected twice | `.claude/rules/<topic>.md` with `paths:` frontmatter |
| The same review or test job comes up again | `.claude/agents/<name>.md` |
| A multi-step procedure is done twice | `.claude/skills/<name>/SKILL.md` |
| A design decision needs explaining | `docs/<topic>.md`, linked from here |
| `CLAUDE.md` nears 200 lines | Move content to the places above |

When you notice one of these, suggest the addition instead of adding it
silently.
