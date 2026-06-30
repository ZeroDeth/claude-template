---
description: Persistent memory protocol via {{MEMORY_MCP}}. Global -- no paths filter.
---

# Memory protocol

`{{MEMORY_MCP}}` is the memory MCP tool prefix for this project. In the
reference stack this is `mcp__claude_ai_MemPalace` (MemPalace MCP server).
Wing for this project: `{{MEMORY_WING}}`.

If `{{MEMORY_MCP}}` is not configured (fresh clone, no MCP server wired),
this rule is a no-op. The session proceeds without memory; nothing breaks.

## Protocol (four mandatory steps)

**ON WAKE-UP**: Call `{{MEMORY_MCP}}__status` to load the palace overview
and confirm the server is reachable.

**BEFORE RESPONDING** about any person, project, or past decision: call
`{{MEMORY_MCP}}__search` or `{{MEMORY_MCP}}__kg_query` first. Never guess
from training data when project-specific facts may exist in the palace.

**AFTER EACH SESSION**: call `{{MEMORY_MCP}}__diary_write` to record:

- Decisions made and the reason behind each.
- Discoveries (unexpected behaviour, API quirks, constraint violations).
- Deferred actions (things not done and why).
- Wing: `{{MEMORY_WING}}`. Room: `decisions` or `diary` as appropriate.

**WHEN FACTS CHANGE**: call `{{MEMORY_MCP}}__kg_invalidate` on the old fact,
then `{{MEMORY_MCP}}__kg_add` for the new one. Stale facts are worse than
no facts.

## Hook setup (operator-local, not committed)

Add to `.claude/settings.json` or `.claude/settings.local.json` after
running `scripts/bootstrap.sh`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Memory: call {{MEMORY_MCP}}__status on first turn'"
          }
        ]
      }
    ]
  }
}
```

See `docs/SETUP.md` for the full hook wiring procedure.
