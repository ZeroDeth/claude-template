# Orchestration -- {{PROJECT_NAME}}

Patterns for composing multiple subagents on a single piece of work.
Individual subagent role definitions live in `.claude/agents/*.md` as
frontmatter-driven files; this document describes how to combine them.

Subagents inherit the rules from `CLAUDE.md`, `AGENTS.md`, and any
`.claude/rules/*.md` that match the files they are editing. They do
not inherit skills; if a subagent needs a skill, preload it via the
skill's name or reference the skill file path in the subagent's
prompt.

The agents in `.claude/agents/` set no `model` field, so they run on the
main conversation's model unless the caller passes a `model` for one
invocation or `CLAUDE_CODE_SUBAGENT_MODEL` is set. Add `model:` (an alias
such as `sonnet`, or `inherit`) or `effort:` to an agent's frontmatter to
pin it. Subagents also inherit the configured advisor when their model
accepts it. See <https://code.claude.com/docs/en/sub-agents#choose-a-model>.

## Pattern: Review-after-implement

Use when one agent implements a feature and another reviews it in a
fresh context. The reviewer is not biased toward code it just wrote.

```text
Main agent:
  1. Implement the feature directly or delegate to a task-specific
     subagent (replace with your project's implementer agents).
  2. Run the code-reviewer subagent on the resulting diff:
       "Review the changes in git diff main...HEAD for correctness,
        error handling, tests, and docs drift."
  3. Address the review findings.
  4. Run the /before-commit skill.
```

## Pattern: Test-then-fix

Use when fixing a bug: one subagent writes a failing test that pins
the expected behaviour, another diagnoses and fixes the root cause,
the main agent runs the test to confirm the fix.

```text
Main agent:
  1. Capture the bug reproduction (error output, logs, screenshots).
  2. Spawn subagents in parallel:

     Subagent A: test-writer
       Input: expected behaviour
       Output: a failing regression test

     Subagent B: a project-specific debugger or general-purpose agent
       Input: reproduction + logs
       Output: root cause + minimal fix proposal

  3. Apply the fix from subagent B.
  4. Run the failing test from subagent A; it must now pass.
  5. Run the /before-commit skill.
```

## Pattern: Coverage push

Use when multiple packages need test coverage. Fan out `test-writer`
subagents, one per package, up to three in parallel.

```text
Main agent:
  1. Run the coverage report to identify gaps.
  2. Spawn subagents (max 3 parallel):

     Subagent A: test-writer for {{PACKAGE_A}}
     Subagent B: test-writer for {{PACKAGE_B}}
     Subagent C: test-writer for {{PACKAGE_C}}

  3. After all subagents return:
     - Run the full test suite.
     - Verify per-package coverage targets.
     - Run the code-reviewer subagent on the aggregate diff.
```

## DOER / CHECKER principle

Agents must not verify their own work. The checker runs independent
verification -- a separate subagent, a separate tool call with fresh context,
or a CI gate -- and the result is machine-readable (exit code, HTTP status,
diff content). Nothing merges until the checker passes.

Apply this principle inside every pattern in this document: the agent that
implements a change is never the agent that confirms it is correct.

## Pattern: Loop with /goal

Use when the success criteria are machine-checkable and the work may take
multiple iterations. The `/goal` skill handles the DOER / CHECKER cycle
automatically.

```text
Main agent:
  1. Invoke /goal:
       END STATE:   <one-sentence observable outcome>
       EVIDENCE:    <exact command whose exit code or output proves success>
       CONSTRAINTS: <what must never be violated>
       CEILING:     <turn or budget limit>
  2. DOER implements one slice per iteration.
  3. CHECKER runs EVIDENCE as a separate step after each DOER slice.
  4. On success: /goal surfaces proof to human and runs /before-commit.
  5. On ceiling: /goal surfaces current state and blocker to human.
```

## Pattern: Delegate with memory

Use when the task splits into independent units and you want memory context
carried into each subagent. The `/delegate` skill structures this.

```text
Main agent:
  1. Invoke /delegate with UNITS, MEMORY QUERY, and REVIEW target.
  2. /delegate loads {{MEMORY_MCP}} context, dispatches subagents in parallel
     (max 3), uses worktrees for file-writing agents.
  3. code-reviewer runs on the aggregate diff after all subagents return.
  4. /delegate writes the session diary to {{MEMORY_MCP}}.
  5. Run /before-commit.
```

## When NOT to orchestrate

A single subagent or direct work in the main session is usually
enough. Fan out only when:

- The work splits cleanly along file boundaries (each subagent owns a
  disjoint set of files).
- The subagents do not need to see each other's output mid-task.
- Merging their output back is cheap (a single code-reviewer pass is
  sufficient).

If any of those fail, do the work in a single session instead. Agent
teams (independent Claude Code sessions with peer-to-peer messaging)
are the next step up if even a single fan-out is not enough. See
<https://code.claude.com/docs/en/agent-teams>.
