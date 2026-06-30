---
name: delegate
description: Dispatch independent work units to parallel subagents with memory context loaded and results reviewed. Invoke as /delegate. Composes {{MEMORY_MCP}} and the /goal primitive.
---

# /delegate -- parallel subagent dispatch

Structures multi-unit work across parallel subagents with memory awareness,
worktree isolation for file writers, and a mandatory review pass before merge.
See `docs/HARNESS.md` and `docs/ORCHESTRATION.md` for the theory.

## When to use

Use `/delegate` when the work splits cleanly along file or domain boundaries
and each subagent owns a disjoint set of files. If subagents need to see each
other's output mid-task, do the work in a single session instead.

## Steps

### 1. Load memory context

```text
Call {{MEMORY_MCP}}__search with the goal as the query.
Note past decisions that constrain this work.
If {{MEMORY_MCP}} is not configured, skip this step.
```

### 2. Identify work units

Decompose the task into independent units. Each unit must:

- Own a disjoint set of files (no two units write the same file).
- Have a clear input and a machine-verifiable output.
- Be completable without knowing the other units' results mid-run.

Maximum 3 parallel units unless explicitly overridden by the caller.

### 3. Dispatch subagents

For each unit, provide:

```text
- Task description (what to do, one paragraph).
- Relevant memory context (paste the search results from step 1).
- Success criteria (what does done look like?).
- /goal invocation if the unit is itself multi-step (include END STATE,
  EVIDENCE, CONSTRAINTS, CEILING).
- Isolation: worktree if the subagent writes files; shared tree if read-only.
```

Available subagents in this template:

- `code-reviewer`: review a diff for correctness, error handling, tests,
  docs drift. Read-only.
- `test-writer`: fill test-coverage gaps for a package. Writes test files.
- `docs-writer`: update human-facing documentation. Writes docs files.

Add project-specific subagents in `.claude/agents/`.

### 4. Collect and review results

After all subagents return:

```text
- Run the code-reviewer subagent on the aggregate diff.
- If the reviewer raises BLOCKER findings: fix before proceeding.
- If WARNING or SUGGESTION only: caller decides.
```

### 5. Write session diary

```text
Call {{MEMORY_MCP}}__diary_write with:
- What each subagent did.
- Decisions made during dispatch (why units were split this way).
- Findings from the review pass.
- Wing: {{MEMORY_WING}}.
```

### 6. Commit

Run `/before-commit` before staging anything.

## Hermes Agent integration (optional)

If Hermes Agent is running alongside Claude Code (see `docs/HARNESS.md`),
you can delegate always-on units to Hermes while Claude Code handles
in-session units. Hermes can also generate new skill files from the
patterns it observes in delegated work -- see `docs/HARNESS.md` for setup.

## Example invocation

```text
/delegate
  UNITS:
    A: test-writer for pkg/auth -- fill coverage gaps, worktree isolation.
    B: test-writer for pkg/store -- fill coverage gaps, worktree isolation.
    C: code-reviewer on main...HEAD -- correctness and docs drift, shared tree.
  MEMORY QUERY: "auth store test coverage decisions"
  REVIEW: run code-reviewer on aggregate diff after A and B return.
```
