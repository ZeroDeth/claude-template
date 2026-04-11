---
name: before-commit
description: Run the full validation sequence before committing changes (tests with race/parallel detector, build, linter, pre-commit hooks, steering-budget check). Invoke manually via /before-commit. Claude will not auto-run this skill because it takes several minutes and has side effects.
disable-model-invocation: true
---

# Before any commit

Run this skill manually before every commit. Claude will not trigger
it automatically.

## Pre-flight checklist

- [ ] Working on a feature branch. The `no-commit-to-branch` pre-commit
      hook blocks commits to `main`; if you land on `main` by accident,
      `git switch -c` to a feature branch.
- [ ] No new dependencies in the manifest (`package.json`, `go.mod`,
      `pyproject.toml`, `Cargo.toml`, etc.) without prior approval.
- [ ] `docs/` updated if the change affects public behaviour.
- [ ] No dangling TODO comments without a tracking entry in `TODO.md`.

## Full validation sequence

Replace each line below with the project's actual build, test, and
lint commands. Every command must exit 0.

```bash
# 1. Format
{{FORMAT_COMMAND}}

# 2. Lint and static analysis
{{LINT_COMMAND}}

# 3. Unit tests with race/parallel detection
{{TEST_COMMAND}}

# 4. Build
{{BUILD_COMMAND}}

# 5. Integration tests (if any)
{{INTEGRATION_TEST_COMMAND}}

# 6. Pre-commit hooks (includes the Claude structure drift guard)
pre-commit run --all-files
```

## Steering-budget check

Anthropic's published target is under 200 lines for `CLAUDE.md`.
The `scripts/check-claude-structure.sh` drift guard enforces this
automatically as part of `pre-commit run --all-files` above, but you
can run it standalone:

```bash
scripts/check-claude-structure.sh
```

## If anything fails

- Format / lint failure: fix the warning. Do not silence it.
- Test failure: fix the broken test or the broken production code.
  Do not skip the test.
- Build failure: the code does not compile; fix it.
- Pre-commit failure: never bypass hooks. Fix the underlying issue
  the hook caught.
- Drift guard failure: see the specific error message. Most common
  causes are `CLAUDE.md` growing past 200 lines or a new tracked file
  referencing a machine-local path.

## Only then

```bash
git add <specific files>
git commit
```

Do not use `git add -A` or `git add .`; they sweep up secrets, editor
scratch files, build artefacts, and other things you did not mean to
stage.
