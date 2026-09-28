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

# The workflow's GITHUB_TOKEN can't read these private repos; bump them by hand.
# Any other read failure is a real breakage and fails the run (#12).
EXPECTED_UNREADABLE=" gitnexus-edit-augment pattern-tracker "

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
  if ! CONTENT=$(gh api "repos/$REPO/contents/.claude-plugin/plugin.json" --jq '.content' 2>&1); then
    if [[ "$EXPECTED_UNREADABLE" == *" $NAME "* ]]; then
      echo "  skip: $NAME (private repo, not readable by this token)"
      SKIPPED=$((SKIPPED + 1))
    else
      echo "  fail: $NAME — could not read $REPO: $(printf '%s' "$CONTENT" | tail -1)"
      FAILED=$((FAILED + 1))
    fi
    continue
  fi
  REMOTE_VERSION=$(printf '%s' "$CONTENT" | base64 -d 2>/dev/null | jq -r '.version // empty' 2>/dev/null) || true

  if [ -z "$REMOTE_VERSION" ]; then
    echo "  fail: $NAME — no version in $REPO/.claude-plugin/plugin.json"
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
[ "$FAILED" -eq 0 ] || exit 1
