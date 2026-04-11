# Conventions -- {{PROJECT_NAME}}

Detailed code style, testing strategy, and project-wide conventions.

Path-scoped subsets of these rules are mirrored in `.claude/rules/` so
Claude Code loads them conditionally when touching matching files.
This file is the full reference and the canonical source.

See also:

- `docs/ARCHITECTURE.md` for package layout and dependency direction
- `docs/ORCHESTRATION.md` for multi-agent composition patterns
- `.claude/rules/docs.md` for documentation style
- `.claude/rules/tests.md` for test conventions

---

## 1. Code style

Replace this section with the project's actual style rules. Include
concrete good/bad examples where possible.

### Example rule: error handling

```text
CORRECT: wrap errors with context using the language's error-wrapping idiom.
WRONG:   bare return of an error with no context.
WRONG:   swallow an error by logging it and continuing.
```

### Example rule: logging

```text
CORRECT: structured logging with named fields.
WRONG:   printf-style concatenation of field values into a single string.
```

## 2. Public API contracts

Document the contracts the project exposes (HTTP, gRPC, CLI, library
functions). Cover:

- Required inputs and validation
- Response shapes
- Error formats and status codes
- Idempotency guarantees

## 3. Testing strategy

- Unit tests colocated with source files.
- Integration tests under `{{INTEGRATION_TEST_PATH}}`.
- Coverage targets per package live in `.claude/rules/tests.md`.

## 4. File and directory layout

Document naming conventions for files, test files, and module
boundaries.

## 5. Dependency policy

Document when a new dependency is acceptable and when it must be
escalated. Include the process: "open a PR that only adds the
dependency, with a one-paragraph justification in the PR body."
