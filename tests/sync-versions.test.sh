#!/bin/bash
# Runs scripts/sync-versions.sh against a fixture marketplace and a stubbed gh.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0

run_case() {  # name, expected exit, fixture plugins json, then assertions via globals
  local name="$1" want="$2" plugins="$3"
  T=$(mktemp -d)
  mkdir -p "$T/scripts" "$T/.claude-plugin" "$T/bin"
  cp "$ROOT/scripts/sync-versions.sh" "$T/scripts/"
  printf '{"plugins": %s}\n' "$plugins" > "$T/.claude-plugin/marketplace.json"
  cat > "$T/bin/gh" <<'STUB'
#!/bin/bash
[ "$1 $3 $4" = "api --jq .content" ] || { echo "unexpected gh argv: $*" >&2; exit 99; }
case "$2" in
  repos/o/good/contents/.claude-plugin/plugin.json) printf '{"version":"2.0.0"}' | base64 ;;
  repos/o/same/contents/.claude-plugin/plugin.json) printf '{"version":"1.0.0"}' | base64 ;;
  repos/o/noversion/contents/.claude-plugin/plugin.json) printf '{}' | base64 ;;
  *) echo "gh: Not Found (HTTP 404)" >&2; exit 1 ;;
esac
STUB
  chmod +x "$T/bin/gh"
  set +e
  OUT=$(PATH="$T/bin:$PATH" bash "$T/scripts/sync-versions.sh" 2>&1)
  RC=$?
  set -e
  MKT="$T/.claude-plugin/marketplace.json"
  [ "$RC" = "$want" ] || { echo "FAIL $name: exit $RC, want $want"; echo "$OUT"; exit 1; }
}

check() { grep -qF -- "$1" <<<"$OUT" || { echo "FAIL $CASE: missing '$1'"; echo "$OUT"; exit 1; }; }
nocheck() { ! grep -qF -- "$1" <<<"$OUT" || { echo "FAIL $CASE: unexpected '$1'"; echo "$OUT"; exit 1; }; }
ok() { echo "PASS: $CASE"; PASS=$((PASS + 1)); rm -rf "$T"; }

CASE="expected-unreadable private repos skip and exit 0"
run_case "$CASE" 0 '[
  {"name":"good","source":{"repo":"o/good"},"version":"1.0.0"},
  {"name":"gitnexus-edit-augment","source":{"repo":"nhangen/gitnexus-edit-augment"},"version":"0.1.0"},
  {"name":"pattern-tracker","source":{"repo":"nhangen/cc-pattern-tracker"},"version":"0.3.0"}]'
check "skip: gitnexus-edit-augment"; check "skip: pattern-tracker"; nocheck "fail:"
check "bump: good 1.0.0 → 2.0.0"
[ "$(jq -r '.plugins[0].version' "$MKT")" = "2.0.0" ] || { echo "FAIL $CASE: bump not written"; exit 1; }
ok

CASE="unexpected read failure exits 1, keeps gh error, still writes other bumps"
run_case "$CASE" 1 '[
  {"name":"renamed","source":{"repo":"o/renamed"},"version":"1.0.0"},
  {"name":"good","source":{"repo":"o/good"},"version":"1.0.0"}]'
check "fail: renamed"; check "Not Found (HTTP 404)"; check "1 failed"
[ "$(jq -r '.plugins[1].version' "$MKT")" = "2.0.0" ] || { echo "FAIL $CASE: good bump lost"; exit 1; }
ok

CASE="plugin.json without a version is a failure"
run_case "$CASE" 1 '[{"name":"nov","source":{"repo":"o/noversion"},"version":"1.0.0"}]'
check "fail: nov"; check "no version"
ok

CASE="up to date and no-source entries exit 0"
run_case "$CASE" 0 '[
  {"name":"same","source":{"repo":"o/same"},"version":"1.0.0"},
  {"name":"local","source":{"path":"./x"},"version":"0.1.0"}]'
check "ok:   same 1.0.0"; check "skip: local (no source repo)"; check "0 failed"
ok

echo "all $PASS passed"
