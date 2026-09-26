---
description: When and how to escalate to a reviewer model. Global -- no paths filter.
---

# Escalation rule

`{{REVIEWER_TOOL}}` is the reviewer model for this project. In the reference
stack this is the Claude Code `advisor` tool, a stronger model that reads
the whole conversation and returns guidance. The operator turns it on with
`/advisor` (see `docs/SETUP.md`); Claude decides when to call it, and this
rule tells it when this project wants that to happen.

If the advisor is off or unavailable (any provider other than the
Anthropic API, or telemetry disabled), run the `code-reviewer` subagent
at the same points instead.

## When to escalate

Consult `{{REVIEWER_TOOL}}`:

- Before starting a non-trivial implementation, once the approach is
  chosen but before building on it.
- When an interpretation is ambiguous and guessing wrong costs rework.
- Before declaring a non-trivial task done.
- After two failed attempts at the same problem, or before changing
  approach.

## How to use the result

If the advice conflicts with something you observed (the file says X, the
test shows Y), raise the conflict in a second consultation rather than
silently picking a side. If you decide not to follow advice, say why.

## When not to escalate

- Trivial one-line fixes where the next step is dictated by tool output
  you just read.
- To avoid making a decision you already have the evidence for.
