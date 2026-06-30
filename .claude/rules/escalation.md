---
description: When and how to escalate to a reviewer model. Global -- no paths filter.
---

# Escalation rule

`{{REVIEWER_TOOL}}` is the reviewer model for this project. In the reference
stack this is the `advisor` tool (Claude Code built-in); replace with the
`code-reviewer` subagent or any strong-model reviewer if `advisor` is not
available.

## When to escalate (mandatory)

Call `{{REVIEWER_TOOL}}` before:

- Starting any non-trivial implementation -- before writing, before committing
  to an interpretation, before building on an assumption.
- Confirming a high-ambiguity interpretation where guessing wrong costs rework.
- Declaring a non-trivial task done.

Call `{{REVIEWER_TOOL}}` when:

- Stuck after two failed attempts at the same problem.
- Considering a change of approach.
- Results do not fit the expected shape.

## How to use the result

Give the advice serious weight. If empirical evidence (the file says X,
the test shows Y) conflicts with the reviewer's claim, do not silently
switch. Surface the conflict in a second escalation call:
"I found X, you suggest Y -- which constraint breaks the tie?" That is
cheaper than committing to the wrong branch.

A passing self-test is not evidence the advice is wrong; it is evidence the
test does not check what the advice is checking.

## What NOT to do

- Do not escalate for trivial one-liner fixes where the next action is
  dictated by tool output you just read.
- Do not escalate to avoid making a decision; escalation is for genuine
  uncertainty, not avoidance.
- Do not ignore escalation output. If you decide not to follow it, record why.
