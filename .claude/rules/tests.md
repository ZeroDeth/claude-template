---
paths:
  - "**/*_test.*"
  - "**/test_*.*"
  - "**/*.test.*"
  - "**/*.spec.*"
  - "**/tests/**"
  - "**/test/**"
---

# Test rules

Loaded only when Claude is reading or editing test files.

## Style

- Test names follow `Test{Function}_{scenario}` or the equivalent
  convention for the language (`describe/it` blocks in JS, parametrized
  pytest functions, JUnit method names).
- Use table-driven tests when there are 3+ cases for the same function.
- Test error paths, not just happy paths.
- Do not modify the code under test from inside a test file. If a test
  reveals a bug, report it; do not silently fix it.
- Prefer standard-library test runners and assertions over third-party
  frameworks unless the project already depends on one. Consistency
  with the existing test suite wins.

## Coverage targets per package

Replace the rows below with the actual targets for this project.

| Package / path | Min coverage | What to cover |
|----------------|--------------|---------------|
| `{{CORE_PACKAGE}}` | 85% | Happy paths, error paths, edge cases |
| `{{INFRA_PACKAGE}}` | 80% | Connection errors, retries, timeouts |
| `{{HTTP_HANDLERS}}` | 85% | Status codes, response shapes, validation |

## Integration tests

Integration tests live under `{{INTEGRATION_TEST_PATH}}` and run
against a real (or in-process) dependency rather than a mock. Mark
them with a language-appropriate tag so unit runs stay fast.

## Adding tests for a new feature

Follow the checklist in the `/before-commit` skill
(`.claude/skills/before-commit/SKILL.md`) before committing new tests.
