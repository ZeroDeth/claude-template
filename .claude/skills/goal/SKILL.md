---
name: goal
description: Structure any multi-step task as a self-verifying DOER/CHECKER loop. Invoke as /goal. Caller provides end state, machine-checkable evidence, constraints, and a turn ceiling.
---

# /goal -- loop primitive

Turns a task into a closed, self-verifying agentic loop. The human defines
the goal once; the loop runs until the success evidence is met or the ceiling
is hit. See `docs/HARNESS.md` for the theory behind this pattern.

## Inputs (caller must provide all four)

```text
END STATE    What does done look like? (one sentence, observable)
EVIDENCE     Machine-checkable signal: test exits 0, diff is empty,
             endpoint returns 200, lint passes, file exists at path X.
CONSTRAINTS  What must never be violated regardless of progress:
             no force-push, no schema change without approval, etc.
CEILING      Maximum turns OR budget before surfacing to the human.
             Example: "10 turns" or "$2 API budget".
```

If any input is missing, ask before starting. A loop without a ceiling runs
unchecked.

## Loop structure

```text
SETUP
  1. Load memory context (call {{MEMORY_MCP}}__search for past decisions
     related to the goal, if {{MEMORY_MCP}} is configured).
  2. Call {{REVIEWER_TOOL}} to validate the approach before starting.

DOER PHASE (per iteration)
  3. Implement one slice toward the END STATE.
  4. Stop after one coherent unit of work -- do not implement everything
     in one pass.

CHECKER PHASE (per iteration, mandatory)
  5. Run the EVIDENCE check as a separate step.
     - Run the actual command or tool call, not a visual inspection.
     - The DOER must not skip the CHECKER to save turns.
  6. If EVIDENCE passes: go to SUCCESS.
  7. If ceiling reached: go to CEILING HIT.
  8. If EVIDENCE fails: return to DOER PHASE.

SUCCESS
  9. Surface to the human with:
     - What was done (brief).
     - The evidence output proving success (paste the actual output).
     - Any constraints that were tested and held.
  10. Write session diary: {{MEMORY_MCP}}__diary_write with decisions
      and discoveries.
  11. Run /before-commit.

CEILING HIT
  12. Surface to the human with:
      - Current state (what is done, what is not).
      - Blocker or reason the ceiling was reached.
      - Recommended next step.
  13. Do not attempt to squeeze one more iteration past the ceiling.
```

## DOER / CHECKER rules

- The CHECKER is a separate verification step, not the DOER confirming its
  own work. Minimum separation: a distinct tool call with the command run
  and its output read.
- If the project has a `test-writer` or `code-reviewer` subagent, use them
  as the CHECKER for their respective domains.
- Nothing proceeds past the CHECKER unless the evidence passes.

## Example invocation

```text
/goal
  END STATE:   The /health endpoint returns HTTP 200 with {"status":"ok"}.
  EVIDENCE:    curl -sf http://localhost:8080/health | grep '"status":"ok"'
  CONSTRAINTS: Do not modify the database schema. Do not touch auth middleware.
  CEILING:     8 turns.
```
