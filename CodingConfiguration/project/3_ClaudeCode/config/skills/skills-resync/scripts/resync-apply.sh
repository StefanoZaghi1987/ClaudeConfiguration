#!/usr/bin/env bash
# Mechanical half of skills-resync step 6: stage from upstream, verify, swap in, keep a backup.
# Protected local edits (L1-L4, L8) are re-applied by hand afterwards - see SKILL.md step 7.
#
# Usage: resync-apply.sh <skill>=<upstream-dir> [<skill>=<upstream-dir> ...]
#        resync-apply.sh --self-test
#
# Upstream paths are passed in, not resolved here: SKILL.md's inventory table and step 1 are the
# single source of truth for them, and version directories move.
set -euo pipefail

SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"

# Stage, verify, then swap. Nothing under $SKILLS_DIR is touched until a verified copy exists, so a
# failed copy can never leave a skill half-written or missing.
apply_one() {                       # $1 skill  $2 upstream dir  $3 work dir
  local skill=$1 upstream=$2 work=$3
  local live="$SKILLS_DIR/$skill" stage="$work/stage/$skill" backup="$work/backup/$skill"

  [ -d "$upstream" ] || { echo "  $skill: upstream missing ($upstream)" >&2; return 1; }
  [ -d "$live" ]     || { echo "  $skill: not vendored locally ($live)" >&2; return 1; }

  mkdir -p "$work/stage" "$work/backup"
  cp -r "$upstream" "$stage"
  if ! diff -rq --strip-trailing-cr "$upstream" "$stage" >/dev/null; then
    echo "  $skill: staged copy does not match upstream, nothing changed" >&2
    return 1
  fi

  mv "$live" "$backup"
  if ! mv "$stage" "$live"; then
    mv "$backup" "$live"
    echo "  $skill: swap failed, original restored" >&2
    return 1
  fi
  echo "  $skill: written"
}

self_test() {
  local root; root=$(mktemp -d)
  # shellcheck disable=SC2064
  trap "rm -rf '$root'" RETURN

  mkdir -p "$root/up/demo" "$root/skills/demo" "$root/work"
  printf 'new\n'   > "$root/up/demo/SKILL.md"
  printf 'old\n'   > "$root/skills/demo/SKILL.md"
  printf 'stale\n' > "$root/skills/demo/dropped-upstream.md"

  SKILLS_DIR="$root/skills"

  apply_one demo "$root/up/demo" "$root/work" >/dev/null
  [ "$(cat "$root/skills/demo/SKILL.md")" = new ] \
    || { echo "self-test FAIL: content not replaced" >&2; return 1; }
  [ ! -e "$root/skills/demo/dropped-upstream.md" ] \
    || { echo "self-test FAIL: file deleted upstream survived locally" >&2; return 1; }
  [ -f "$root/work/backup/demo/SKILL.md" ] \
    || { echo "self-test FAIL: no backup taken" >&2; return 1; }

  # A missing upstream must leave the live copy untouched.
  printf 'keep\n' > "$root/skills/demo/SKILL.md"
  if apply_one demo "$root/up/absent" "$root/work" 2>/dev/null; then
    echo "self-test FAIL: missing upstream reported success" >&2; return 1
  fi
  [ "$(cat "$root/skills/demo/SKILL.md")" = keep ] \
    || { echo "self-test FAIL: live copy touched despite missing upstream" >&2; return 1; }

  echo "self-test OK"
}

usage() {
  echo "Usage: resync-apply.sh <skill>=<upstream-dir> [<skill>=<upstream-dir> ...]"
  echo "       resync-apply.sh --self-test"
}

[ $# -gt 0 ] || { usage; exit 2; }
[ "$1" = --self-test ] && { self_test; exit $?; }

WORK=$(mktemp -d)
# shellcheck disable=SC2064
trap "rm -rf '$WORK'" EXIT          # fires on success, failure and interrupt

written=0 failed=0
for pair in "$@"; do
  case "$pair" in
    *=*) ;;
    *) echo "  expected <skill>=<upstream-dir>, got: $pair" >&2; failed=$((failed + 1)); continue ;;
  esac
  if apply_one "${pair%%=*}" "${pair#*=}" "$WORK"; then
    written=$((written + 1))
  else
    failed=$((failed + 1))
  fi
done

echo "written=$written failed=$failed"
echo "Re-apply protected local edits now (SKILL.md step 7), then re-verify."
[ "$failed" -eq 0 ]
