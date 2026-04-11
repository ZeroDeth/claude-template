# Architecture -- {{PROJECT_NAME}}

Replace this stub with the actual system design.

## Overview

One paragraph: what the project is, what problem it solves, and the
shape of the solution at a high level.

## Package layout

```text
{{PROJECT_ROOT}}/
├── {{SOURCE_DIR}}/       -- main source code
├── {{TEST_DIR}}/         -- tests
├── docs/                 -- long-form documentation (this directory)
├── scripts/              -- project scripts (including drift guard)
└── .claude/              -- Claude Code steering structure
    ├── rules/            -- path-scoped conventions
    ├── agents/           -- subagent role definitions
    └── skills/           -- slash-invokable playbooks
```

## Dependency direction

Document which packages may import which. Example:

- `{{CMD_PACKAGE}}` may import any `{{INTERNAL_PACKAGE}}`
- `{{CORE_PACKAGE}}` may not import `{{CMD_PACKAGE}}`
- No circular imports

## Request flow (if applicable)

If this is a service or CLI, describe the flow from input to output:

1. Entry point: {{ENTRY_POINT}}
2. Routing / dispatch: {{DISPATCHER}}
3. Business logic: {{CORE_LOGIC}}
4. Storage / external calls: {{PERSISTENCE}}
5. Response: {{RESPONSE}}

## Diagrams

If you use mermaid or similar, inline them here.
