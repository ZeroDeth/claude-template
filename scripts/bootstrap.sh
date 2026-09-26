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
# Every other {{PLACEHOLDER}} in the scaffold is yours to fill in as
# the project takes shape. This script does not hand-maintain a list
# of them (such a list goes stale the moment a doc is added); it scans
# the tree after substituting and reports exactly what is left.

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

# Files to process are DISCOVERED, not hand-listed. A hardcoded list
# silently misses every doc added to the template later, leaving raw
# {{PLACEHOLDER}} markers in the generated project. Anything tracked
# in the scaffold with a text extension is fair game.
#
# `find` rather than `git ls-files` on purpose: TEMPLATE.md's Method 2
# runs this script right after `rm -rf .git && git init`, where the
# index is empty and `git ls-files` returns nothing.
#
# Excluded: scripts/ (both scripts carry literal {{PLACEHOLDER}}
# patterns that substitution would corrupt) and TEMPLATE.md
# (meta-documentation you delete).
# `while read` rather than `mapfile`: macOS still ships bash 3.2,
# which has no mapfile.
files=()
while IFS= read -r f; do
  files+=("$f")
done < <(
  find . \
    \( -path ./.git -o -path ./scripts -o -path ./node_modules \
       -o -path ./vendor -o -path ./.venv -o -path ./target \
       -o -path ./dist -o -path ./build \) -prune -o \
    -type f \( -name '*.md' -o -name '*.yaml' -o -name '*.yml' \
       -o -name '*.json' \) -print \
  | sed 's|^\./||' \
  | grep -v '^TEMPLATE\.md$' \
  | sort
)

if [ "${#files[@]}" -eq 0 ]; then
  echo "error: no scaffold files found to process" >&2
  exit 1
fi

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

# Report what is still unfilled rather than telling the reader to go
# find out for themselves.
remaining=$(grep -rhoE '\{\{[A-Z_]+\}\}' "${files[@]}" 2>/dev/null \
  | sort -u | grep -v '^{{PLACEHOLDER}}$' || true)

echo
if [ -n "$remaining" ]; then
  count=$(printf '%s\n' "$remaining" | wc -l | tr -d ' ')
  echo "Remaining placeholders to fill in ($count):"
  printf '%s\n' "$remaining" | sed 's/^/  /'
  echo
  echo "  Locate them with:"
  echo "    grep -rEn '\{\{[A-Z_]+\}\}' . --include='*.md' --include='*.yaml' \\"
  echo "      --include='*.yml' --include='*.json'"
else
  echo "No placeholders remain."
fi

echo
echo "Next steps:"
echo "  1. Fill in the placeholders listed above as the project takes"
echo "     shape. Not all of them apply to every stack."
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
