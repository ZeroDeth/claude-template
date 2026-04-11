---
name: example-playbook
description: Example skill showing the structure of a multi-step playbook. Replace this file with real project-specific skills (e.g., add-feature, deploy, run-migration). Delete this example once your project has its own skills.
---

# Example playbook

This is a placeholder so contributors can see the shape of a real
skill. Replace it with something useful for your project, or delete it
entirely if you only need the `before-commit` skill.

## When to invoke

Describe the scenario that calls for this playbook. A good description
is specific enough that Claude can match the skill automatically when
the user describes the same scenario in natural language.

## Inputs

List what the caller needs to provide. If the caller is the user
typing `/example-playbook` on the command line, you can access the
arguments via `$ARGUMENTS` or `$ARGUMENTS[0]`, `$1`, etc.

## Steps

1. First step, with enough detail that an agent can execute it
   without asking clarifying questions.
2. Second step. Reference specific files by path. Include any commands
   that need to run.
3. Third step, and so on.

Link related material:

- `docs/CONVENTIONS.md` for project style.
- `.claude/agents/code-reviewer.md` to delegate review.
- `.claude/skills/before-commit/SKILL.md` to finalise the change.

## Verification

```bash
# Commands that confirm the playbook succeeded.
{{VERIFY_COMMAND}}
```

## Output

Describe what the skill produces. If it modifies files, list them. If
it runs something destructive, note it.

## Delete this file

Once you have real skills for your project, remove this example:

```bash
rm -rf .claude/skills/example-playbook
```
