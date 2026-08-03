#!/usr/bin/env bash
# Mechanical half of skills-resync: resolve upstream, classify drift, re-vendor, clean up.
# Judgement stays in SKILL.md - which protected edits (L1-L6) a skill carries, and whether a
# remaining diff is one of them. Everything this script does is decidable without reading prose.
#
# Usage: resync.sh --check                      classify every skill in inventory.tsv
#        resync.sh --diff <skill>               full diff for one skill
#        resync.sh --apply <skill> [<skill>...] re-vendor, restore the regime line, rebase shas
#        resync.sh --clean [--dry-run]          sweep own leftovers + orphan temp_git_* clones
#        resync.sh --self-test                  exercise apply/regime/sha paths in a scratch dir
set -euo pipefail

SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"
PLUGINS_JSON="${PLUGINS_JSON:-$HOME/.claude/plugins/installed_plugins.json}"
PLUGIN_CACHE="${PLUGIN_CACHE:-$HOME/.claude/plugins/cache}"
INVENTORY="${INVENTORY:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/inventory.tsv}"

# L6 in SKILL.md: local invocation regime, never upstream state. The script owns re-applying it
# because it is one frontmatter line - the edit most likely to be lost, and the only one that is
# purely mechanical. Every diff below ignores it, so a skill whose only local change is L6 reads
# as identical instead of forcing a hand comparison.
REGIME='disable-model-invocation: true'
REGIME_RE='^disable-model-invocation:'

PY=$(command -v python3 || command -v python) || {
  echo "resync: needs python3 to read $PLUGINS_JSON" >&2; exit 1; }

# --- resolution --------------------------------------------------------------------------------
# installed_plugins.json records installPath and gitCommitSha and the plugin manager keeps both
# current, so no version directory is hardcoded anywhere: a plugin update moves the path and this
# follows it. That is what makes "newest version directory" - wrong for the `unknown`-versioned
# plugins - never a rule this script has to guess at.
plugin_root_and_sha() {             # $1 plugin@marketplace -> "<unix path>\t<sha>" (empty if absent)
  "$PY" -c '
import json, sys
try:
    e = json.load(open(sys.argv[1]))["plugins"].get(sys.argv[2]) or [{}]
except Exception:
    e = [{}]
print(e[0].get("installPath", "") + "\t" + e[0].get("gitCommitSha", ""))' "$PLUGINS_JSON" "$1"
}

# A 12-char baseline and a 40-char gitCommitSha name the same commit; compare on the shorter.
sha_same() {                        # $1 baseline  $2 current
  local a=$1 b=$2 n
  [ -n "$a" ] && [ -n "$b" ] || return 1
  n=${#a}; [ ${#b} -lt "$n" ] && n=${#b}
  [ "$n" -ge 7 ] && [ "${a:0:$n}" = "${b:0:$n}" ]
}

# Empty output means "no difference beyond the regime line". --strip-trailing-cr is mandatory:
# the locally-flagged skills were rewritten CRLF against LF upstream, and without it every line
# reads as changed - skill-creator shows 974 changed lines whose real content is one.
drift_diff() {                      # $1 upstream  $2 live
  diff -r --strip-trailing-cr -I "$REGIME_RE" "$1" "$2" 2>&1 || true
}

# --- inventory ---------------------------------------------------------------------------------
# Emits: skill \t plugin \t subpath \t baseline \t upstream-dir \t current-sha
# upstream-dir is empty when the plugin is gone from installed_plugins.json or its cache was swept.
inventory_resolved() {
  local skill plugin sub base root sha
  while IFS=$'\t' read -r skill plugin sub base || [ -n "$skill" ]; do
    case "$skill" in ''|\#*) continue ;; esac
    IFS=$'\t' read -r root sha < <(plugin_root_and_sha "$plugin")
    [ -n "$root" ] && root=$(cygpath -u "$root" 2>/dev/null || echo "$root")
    [ -n "$root" ] && [ -d "$root/$sub" ] || root=''
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
      "$skill" "$plugin" "$sub" "$base" "${root:+$root/$sub}" "$sha"
  done < "$INVENTORY"
}

lookup() {                          # $1 skill -> resolved row, or exit 1
  inventory_resolved | grep -P "^$1\t" || return 1
}

# --- check -------------------------------------------------------------------------------------
# The two inputs decide the state jointly: the sha says whether upstream moved, the diff says
# whether anything beyond the protected edits is present. Never infer either from diff size.
check() {
  local skill plugin sub base up sha state d n r appliable='' review='' blocked='' regimes=0
  printf '%-32s %-6s %s\n' SKILL REGIME 'STATE / DETAIL'
  while IFS=$'\t' read -r skill plugin sub base up sha; do
    # The diff ignores the regime line, so report it separately: without this a skill that lost
    # its L6 flag out of band would read as identical, which is the one failure this whole skill
    # exists to catch. Reported, not asserted - a deliberate promotion needs no bookkeeping.
    if grep -qE "$REGIME_RE *true" "$SKILLS_DIR/$skill/SKILL.md" 2>/dev/null; then
      r='slash'; regimes=$((regimes + 1))
    else
      r='-'
    fi
    if [ ! -d "$SKILLS_DIR/$skill" ]; then
      state=not-vendored; d="no $SKILLS_DIR/$skill"
    elif [ -z "$up" ]; then
      state=upstream-missing; d="$plugin cache swept or plugin uninstalled"
    else
      n=$(drift_diff "$up" "$SKILLS_DIR/$skill" | grep -c . || true)
      if sha_same "$base" "$sha"; then
        [ "$n" -eq 0 ] && { state=identical;   d=''; } \
                       || { state=local-only;  d="$n diff lines, upstream at baseline"; }
      else
        [ "$n" -eq 0 ] && { state=upstream-changed; d="baseline ${base:0:12} -> ${sha:0:12}"; } \
                       || { state=both-changed;     d="$n diff lines, upstream moved to ${sha:0:12}"; }
      fi
    fi
    printf '%-32s %-6s %s\n' "$skill" "$r" "$state${d:+  $d}"
    case $state in
      upstream-changed) appliable+=" $skill" ;;
      local-only)       review+=" $skill" ;;
      identical)        ;;
      *)                blocked+=" $skill" ;;
    esac
  done < <(inventory_resolved)

  # An unmoved sha with a local diff blocks nothing - there is no upstream change to apply. It
  # only asks one question: is that diff confined to the skill's protected edits (SKILL.md L1-L5)?
  echo
  echo "APPLIABLE:${appliable:- none}      # --apply these after one confirmation"
  echo "REVIEW:${review:- none}      # local-only: confirm the diff is L1-L5, then no action"
  echo "BLOCKED:${blocked:- none}      # upstream moved onto a local edit, or upstream gone"
  local unmapped
  unmapped=$(comm -23 \
    <(cd "$SKILLS_DIR" && ls -d */ 2>/dev/null | tr -d /  | sort) \
    <(cut -f1 "$INVENTORY" | grep -v '^#' | grep . | sort))
  echo "UNMAPPED: $(echo $unmapped)   # expected: the originals with no upstream"
  echo "REGIME: $regimes of $(grep -cvE '^#|^$' "$INVENTORY") mapped skills are slash-only" \
       "(+ $(echo $unmapped | wc -w) unmapped) - reconcile against SKILL.md L6"
}

# --- apply -------------------------------------------------------------------------------------
# Stage, verify, back up, swap. Nothing under $SKILLS_DIR is touched until a verified copy exists,
# so a failed copy can never leave a skill half-written. Replacement is wholesale, not a merge: a
# stale file left behind by an upstream deletion is drift no later diff would catch.
apply_one() {                       # $1 skill  $2 upstream  $3 work -> prints new sha on success
  local skill=$1 up=$2 work=$3
  local live="$SKILLS_DIR/$skill" stage="$work/stage/$skill" backup="$work/backup/$skill" regime=no

  [ -d "$up" ]   || { echo "  $skill: upstream missing ($up)" >&2; return 1; }
  [ -d "$live" ] || { echo "  $skill: not vendored locally ($live)" >&2; return 1; }

  grep -qE "$REGIME_RE *true" "$live/SKILL.md" 2>/dev/null && regime=yes

  mkdir -p "$work/stage" "$work/backup"
  cp -r "$up" "$stage"
  # A copy must be byte-identical - no --strip-trailing-cr here, or a mangled copy verifies clean.
  if ! diff -rq "$up" "$stage" >/dev/null; then
    echo "  $skill: staged copy does not match upstream, nothing changed" >&2; return 1
  fi

  mv "$live" "$backup"
  if ! mv "$stage" "$live"; then
    mv "$backup" "$live"
    echo "  $skill: swap failed, original restored" >&2; return 1
  fi

  if [ "$regime" = yes ] && ! grep -qE "$REGIME_RE" "$live/SKILL.md"; then
    restore_regime "$live/SKILL.md" || { echo "  $skill: WARNING regime line not restored" >&2; }
  fi
  echo "  $skill: written${regime:+ (regime $regime)}" >&2
}

# Re-insert L6 before the closing frontmatter fence. Tolerates CRLF, and refuses a file with no
# frontmatter rather than writing the line into the body where it would be inert.
restore_regime() {                  # $1 SKILL.md
  local f=$1 out="$1.regime"
  awk -v line="$REGIME" '
    /^---\r?$/ { fences++; if (fences == 2) print line; print; next }
    { print }
    END { exit (fences >= 2 ? 0 : 1) }
  ' "$f" > "$out" || { rm -f "$out"; return 1; }
  mv "$out" "$f"
}

# Rebase the inventory in the same pass as the write. Left for later it never happens, and the next
# run then reports every one of these skills as upstream-changed and re-vendors them again.
rebase_baselines() {                # $@ skill=sha
  [ $# -gt 0 ] || return 0
  "$PY" - "$INVENTORY" "$@" <<'PY'
import sys
inv, pairs = sys.argv[1], dict(a.split('=', 1) for a in sys.argv[2:])
out = []
for line in open(inv, encoding='utf-8').read().splitlines(True):
    f = line.rstrip('\n').split('\t')
    if len(f) == 4 and f[0] in pairs:
        f[3] = pairs[f[0]]
        line = '\t'.join(f) + '\n'
    out.append(line)
open(inv, 'w', encoding='utf-8', newline='\n').writelines(out)
PY
}

apply() {
  local work written=0 failed=0 rebase=() skill row up sha
  work=$(mktemp -d "${TMPDIR:-/tmp}/skills-resync-XXXXXX")
  # shellcheck disable=SC2064
  trap "rm -rf '$work'" EXIT        # fires on success, failure and interrupt alike

  for skill in "$@"; do
    if ! row=$(lookup "$skill"); then
      echo "  $skill: not in inventory.tsv" >&2; failed=$((failed + 1)); continue
    fi
    up=$(cut -f5 <<<"$row"); sha=$(cut -f6 <<<"$row")
    if apply_one "$skill" "$up" "$work"; then
      written=$((written + 1)); rebase+=("$skill=$sha")
    else
      failed=$((failed + 1))
    fi
  done

  rebase_baselines "${rebase[@]+"${rebase[@]}"}"
  clean
  echo "written=$written failed=$failed baselines_rebased=${#rebase[@]}"
  echo "L6 restored automatically. Re-apply L1-L5 by hand now (SKILL.md step 5), then --check."
  [ "$failed" -eq 0 ]
}

# --- cleanup ----------------------------------------------------------------------------------
# Everything a resync run can leave behind, plus the marketplace clones the plugin installer
# orphans at cache/temp_git_*. Runs unattended at the end of every --apply.
#
# An orphan younger than ORPHAN_MIN_AGE minutes is left alone and reported: a concurrent plugin
# install does its work inside one of these, and a resync cannot tell a live clone from a corpse
# by name. Age is the knob - lower it when sweeping a machine known to be idle.
ORPHAN_MIN_AGE="${ORPHAN_MIN_AGE:-60}"

clean() {                           # $1 --dry-run to report only
  local dry=${1:-} p targets=() young=0
  for p in "${TMPDIR:-/tmp}"/skills-resync-* /skills-resync-backup; do
    [ -e "$p" ] && targets+=("$p")
  done
  while IFS= read -r p; do targets+=("$p"); done \
    < <(find "$SKILLS_DIR" -maxdepth 2 -name '*.regime' 2>/dev/null)
  while IFS= read -r p; do targets+=("$p"); done \
    < <(find "$PLUGIN_CACHE" -maxdepth 1 -name 'temp_git_*' -mmin +"$ORPHAN_MIN_AGE" 2>/dev/null)
  young=$(find "$PLUGIN_CACHE" -maxdepth 1 -name 'temp_git_*' -mmin -"$ORPHAN_MIN_AGE" 2>/dev/null | grep -c . || true)

  [ "$young" -eq 0 ] || echo "clean: $young temp_git_* younger than ${ORPHAN_MIN_AGE}m kept (may be in use)"
  if [ ${#targets[@]} -eq 0 ]; then echo "clean: nothing to remove"; return 0; fi
  du -sh "${targets[@]}" 2>/dev/null || true
  echo "clean: ${#targets[@]} leftover path(s)$([ -n "$dry" ] && echo ' (dry run, nothing removed)')"
  [ -n "$dry" ] || { rm -rf "${targets[@]}"; echo "clean: removed"; }
}

# --- self-test --------------------------------------------------------------------------------
self_test() {
  local root; root=$(mktemp -d "${TMPDIR:-/tmp}/skills-resync-test-XXXXXX")
  # shellcheck disable=SC2064
  trap "rm -rf '$root'" RETURN

  mkdir -p "$root/up/demo" "$root/skills/demo" "$root/work"
  printf -- '---\nname: demo\n---\nnew\n' > "$root/up/demo/SKILL.md"
  printf -- '---\nname: demo\ndisable-model-invocation: true\n---\nold\n' > "$root/skills/demo/SKILL.md"
  printf 'stale\n' > "$root/skills/demo/dropped-upstream.md"

  SKILLS_DIR="$root/skills"
  INVENTORY="$root/inventory.tsv"
  printf 'demo\tp@m\tskills/demo\tOLDSHA1234567\n' > "$INVENTORY"

  apply_one demo "$root/up/demo" "$root/work" 2>/dev/null
  grep -q '^new$' "$root/skills/demo/SKILL.md" \
    || { echo "self-test FAIL: content not replaced" >&2; return 1; }
  [ ! -e "$root/skills/demo/dropped-upstream.md" ] \
    || { echo "self-test FAIL: file deleted upstream survived locally" >&2; return 1; }
  [ -f "$root/work/backup/demo/SKILL.md" ] \
    || { echo "self-test FAIL: no backup taken" >&2; return 1; }
  [ "$(sed -n 3p "$root/skills/demo/SKILL.md")" = "$REGIME" ] \
    || { echo "self-test FAIL: regime line not restored inside frontmatter" >&2; return 1; }
  [ -z "$(drift_diff "$root/up/demo" "$root/skills/demo")" ] \
    || { echo "self-test FAIL: regime-only diff not ignored" >&2; return 1; }

  rebase_baselines demo=NEWSHA7654321
  grep -q $'demo\tp@m\tskills/demo\tNEWSHA7654321' "$INVENTORY" \
    || { echo "self-test FAIL: baseline not rebased" >&2; return 1; }

  # A missing upstream must leave the live copy untouched.
  printf 'keep\n' > "$root/skills/demo/SKILL.md"
  if apply_one demo "$root/up/absent" "$root/work" 2>/dev/null; then
    echo "self-test FAIL: missing upstream reported success" >&2; return 1
  fi
  [ "$(cat "$root/skills/demo/SKILL.md")" = keep ] \
    || { echo "self-test FAIL: live copy touched despite missing upstream" >&2; return 1; }

  # A body-only file must be refused rather than have the line written into prose.
  printf 'no frontmatter\n' > "$root/skills/demo/SKILL.md"
  if restore_regime "$root/skills/demo/SKILL.md" 2>/dev/null; then
    echo "self-test FAIL: regime line written into a file with no frontmatter" >&2; return 1
  fi
  [ ! -e "$root/skills/demo/SKILL.md.regime" ] \
    || { echo "self-test FAIL: temp file left behind" >&2; return 1; }

  echo "self-test OK"
}

usage() { sed -n '6,10p' "${BASH_SOURCE[0]}" | sed 's/^# \?//'; }

case "${1:---help}" in
  --check)     check ;;
  --diff)      [ $# -eq 2 ] || { usage; exit 2; }
               row=$(lookup "$2") || { echo "$2: not in inventory.tsv" >&2; exit 1; }
               up=$(cut -f5 <<<"$row")
               [ -n "$up" ] || { echo "$2: upstream missing" >&2; exit 1; }
               drift_diff "$up" "$SKILLS_DIR/$2" ;;
  --apply)     shift; [ $# -gt 0 ] || { usage; exit 2; }; apply "$@" ;;
  --clean)     clean "${2:-}" ;;
  --self-test) self_test ;;
  *)           usage; exit 2 ;;
esac
