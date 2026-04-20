#!/bin/bash
set -euo pipefail

# sync-versions.sh — Pull version from each plugin's repo and update marketplace.json.
# Usage: ./scripts/sync-versions.sh [--dry-run]
# Requires: gh, jq

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MARKETPLACE="$SCRIPT_DIR/../.claude-plugin/marketplace.json"
DRY_RUN=false
[ "${1:-}" = "--dry-run" ] && DRY_RUN=true

if [ ! -f "$MARKETPLACE" ]; then
  echo "ERROR: marketplace.json not found at $MARKETPLACE" >&2
  exit 1
fi

UPDATED=0
SKIPPED=0
FAILED=0

# Iterate plugins that have a github source repo
PLUGIN_COUNT=$(jq '.plugins | length' "$MARKETPLACE")

for i in $(seq 0 $((PLUGIN_COUNT - 1))); do
  NAME=$(jq -r ".plugins[$i].name" "$MARKETPLACE")
  REPO=$(jq -r ".plugins[$i].source.repo // empty" "$MARKETPLACE")
  CURRENT=$(jq -r ".plugins[$i].version // empty" "$MARKETPLACE")

  if [ -z "$REPO" ]; then
    echo "  skip: $NAME (no source repo)"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  # Fetch plugin.json from the repo's default branch
  REMOTE_VERSION=$(gh api "repos/$REPO/contents/.claude-plugin/plugin.json" \
    --jq '.content' 2>/dev/null \
    | base64 -d 2>/dev/null \
    | jq -r '.version // empty' 2>/dev/null) || true

  if [ -z "$REMOTE_VERSION" ]; then
    echo "  fail: $NAME — could not read version from $REPO"
    FAILED=$((FAILED + 1))
    continue
  fi

  if [ "$REMOTE_VERSION" = "$CURRENT" ]; then
    echo "  ok:   $NAME $CURRENT (up to date)"
    SKIPPED=$((SKIPPED + 1))
  else
    echo "  bump: $NAME $CURRENT → $REMOTE_VERSION"
    if [ "$DRY_RUN" = false ]; then
      # Update version in marketplace.json using jq
      TMP=$(mktemp)
      jq ".plugins[$i].version = \"$REMOTE_VERSION\"" "$MARKETPLACE" > "$TMP"
      mv "$TMP" "$MARKETPLACE"
      UPDATED=$((UPDATED + 1))
    else
      UPDATED=$((UPDATED + 1))
    fi
  fi
done

echo ""
echo "Done: $UPDATED updated, $SKIPPED up-to-date, $FAILED failed"
if [ "$DRY_RUN" = true ]; then
  echo "(dry run — no files changed)"
fi
