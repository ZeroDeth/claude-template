#!/usr/bin/env bash
#
# Bootstrap a new project from claude-template.
#
# Replaces the most common placeholders across the scaffold:
#
#   {{PROJECT_NAME}}         project name (arg 1)
#   {{OWNER_NAME}}           owner full name (arg 2)
#   {{ONE_LINE_DESCRIPTION}} one-line project description (arg 3)
#   {{DATE}}                 today's date in YYYY-MM-DD
#
# Usage:
#
#   scripts/bootstrap.sh "my-new-project" "Your Name" "A local X emulator."
#
# Placeholders not touched by this script (you fill them in manually
# as the project takes shape):
#
#   {{MODULE_OR_PACKAGE_NAME}}   language-specific module path
#   {{LICENCE}}                  MIT, Apache-2.0, etc.
#   {{BUILD_COMMAND}}            e.g., `go build ./...`, `npm run build`
#   {{TEST_COMMAND}}             e.g., `go test ./...`, `npm test`
#   {{LINT_COMMAND}}             e.g., `golangci-lint run`, `eslint .`
#   {{INSTALL_COMMAND}}          e.g., `go mod download`, `npm install`
#   {{RUN_COMMAND}}              how to start the project locally
#   {{REPO_URL}}                 git remote URL once you push
#   {{STATUS}}                   e.g., "v0.1-dev"
#   {{LANGUAGE_RUNTIME}}         e.g., "Go 1.22+", "Node 20+"
#   {{PACKAGE_MANAGER}}          npm, pnpm, yarn, go, cargo, uv, ...
#   {{CORE_PACKAGE}}             path to the main package
#   {{INTEGRATION_TEST_PATH}}    where integration tests live
#   {{MEMORY_MCP}}               memory MCP tool prefix (e.g. mcp__claude_ai_MemPalace)
#   {{MEMORY_WING}}              MemPalace wing slug for this project
#   {{REVIEWER_TOOL}}            escalation reviewer tool (e.g. advisor)
#   ... and any project-specific placeholder under docs/

set -euo pipefail

if [ $# -lt 3 ]; then
  echo "usage: $0 <project-name> <owner-name> <one-line-description>" >&2
  echo "example: $0 myservice \"Jane Doe\" \"A local mock of the X API.\"" >&2
  exit 1
fi

project_name="$1"
owner_name="$2"
description="$3"
today=$(date +%Y-%m-%d)

cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

echo "Bootstrapping:"
echo "  project     : $project_name"
echo "  owner       : $owner_name"
echo "  description : $description"
echo "  date        : $today"
echo

# Files to process. Limit to documentation and config; skip the drift
# guard and the bootstrap script itself.
files=(
  README.md
  AGENTS.md
  CLAUDE.md
  CHANGELOG.md
  TASKS.md
  TODO.md
  .pre-commit-config.yaml
  docs/ARCHITECTURE.md
  docs/CONVENTIONS.md
  docs/ORCHESTRATION.md
  docs/SETUP.md
  docs/TROUBLESHOOTING.md
  .claude/rules/docs.md
  .claude/rules/tests.md
  .claude/agents/code-reviewer.md
  .claude/agents/test-writer.md
  .claude/agents/docs-writer.md
  .claude/skills/before-commit/SKILL.md
  .claude/skills/example-playbook/SKILL.md
  .claude/skills/goal/SKILL.md
  .claude/skills/delegate/SKILL.md
  .claude/rules/escalation.md
  .claude/rules/memory.md
  docs/HARNESS.md
)

# Use perl because it handles multi-character placeholders identically
# on macOS (BSD sed) and Linux (GNU sed) without the in-place -i
# syntax divergence.
for f in "${files[@]}"; do
  if [ -f "$f" ]; then
    perl -i -pe "s/\{\{PROJECT_NAME\}\}/$project_name/g" "$f"
    perl -i -pe "s/\{\{OWNER_NAME\}\}/$owner_name/g" "$f"
    perl -i -pe "s/\{\{ONE_LINE_DESCRIPTION\}\}/$description/g" "$f"
    perl -i -pe "s/\{\{DATE\}\}/$today/g" "$f"
    perl -i -pe "s/\{\{MEMORY_WING\}\}/$project_name/g" "$f"
    echo "  updated $f"
  fi
done

echo
echo "Next steps:"
echo "  1. Search for remaining {{PLACEHOLDER}} markers and replace"
echo "     them as the project takes shape:"
echo "       grep -rEn '\{\{[A-Z_]+\}\}' . --include='*.md' --include='*.yaml'"
echo "  2. Open .claudeignore and uncomment the dependency directory"
echo "     and lock file lines that match your stack."
echo "  3. Uncomment or add language-specific hooks in"
echo "     .pre-commit-config.yaml."
echo "  4. Run 'pre-commit install' to register the git hook."
echo "  5. Run 'scripts/check-claude-structure.sh' to verify the"
echo "     drift guard is happy."
echo "  6. Delete .claude/skills/example-playbook/ once you have a"
echo "     real project-specific skill, or keep it as a reference."
echo "  7. Delete this bootstrap.sh and TEMPLATE.md once you're done."
