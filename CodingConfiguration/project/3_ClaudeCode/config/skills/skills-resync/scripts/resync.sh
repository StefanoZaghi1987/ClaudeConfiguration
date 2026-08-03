#!/usr/bin/env bash
# Mechanical half of skills-resync: resolve upstream, classify drift, re-vendor, clean up.
# Judgement stays in SKILL.md - which protected edits (L1-L6) a skill carries, and whether a
# remaining diff is one of them. Everything this script does is decidable without reading prose.
#
# Usage: resync.sh --check                      classify every skill in inventory.tsv
#        resync.sh --diff <skill>               full diff for one skill
#        resync.sh --snapshot <skill> [...]     record the skill's local edits as a replayable patch
#        resync.sh --apply <skill> [<skill>...] re-vendor, restore regime + local patch, rebase shas
#        resync.sh --clean [--dry-run]          sweep own leftovers + orphan temp_git_* clones
#        resync.sh --self-test                  exercise apply/regime/patch/sha paths in a scratch dir
set -euo pipefail

SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"
PLUGINS_JSON="${PLUGINS_JSON:-$HOME/.claude/plugins/installed_plugins.json}"
PLUGIN_CACHE="${PLUGIN_CACHE:-$HOME/.claude/plugins/cache}"
INVENTORY="${INVENTORY:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/inventory.tsv}"
PATCHES="${PATCHES:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/patches}"

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

# --- protected local edits as data ---------------------------------------------------------------
# SKILL.md's L1-L5 are line replacements against a known upstream text, so they are data, not prose:
# `patches/<skill>.patch` holds them and `patch` replays them onto a fresh vendor. That is what makes
# a re-vendor of an edited skill mechanical - previously it was a hand step no later check could see
# had been skipped, since a reverted edit reads as `identical` once the baseline is rebased.
#
# A patch that no longer applies is the whole point: the reject names the exact line where upstream
# moved onto a local edit, which is the only case that ever needed judgement.
patch_file() { echo "$PATCHES/$1.patch"; }

# Staged as a/ and b/ so headers are `a/SKILL.md` and `b/SKILL.md` and `patch -p1` is unambiguous -
# diffing the real paths leaves patch guessing the strip depth from an absolute path.
# --strip-trailing-cr is what lets a CRLF live file patch a LF upstream; -N carries added files
# (L4's code-reviewer.md is a whole file that exists only locally).
#
# The mtime is stripped from the ---/+++ headers: the staged copies are fresh every run, so leaving
# it in makes the patch text differ on every generation and the staleness check below cry wolf
# forever. Without it the patch is a stable artifact that only changes when an edit does.
gen_patch() {                       # $1 upstream  $2 live -> patch on stdout
  local t; t=$(mktemp -d "${TMPDIR:-/tmp}/skills-resync-gen-XXXXXX")
  cp -r "$1" "$t/a"; cp -r "$2" "$t/b"
  # L6 has exactly one owner, restore_regime. Leaving it in the patch too makes apply insert it
  # twice: restore_regime writes the line, then the patch hunk finds its own change already there
  # and rejects the whole file - which reads as "upstream moved onto a protected edit" and rolls
  # back a re-vendor that was perfectly applicable. Strip it here so the patch owns only L1-L5.
  [ -f "$t/b/SKILL.md" ] && grep -vE "$REGIME_RE" "$t/b/SKILL.md" > "$t/b/SKILL.md.tmp" \
    && mv "$t/b/SKILL.md.tmp" "$t/b/SKILL.md"
  ( cd "$t" && diff -ruN --strip-trailing-cr a b ) \
    | sed -E 's/^(---|\+\+\+) ([^\t]*)\t.*/\1 \2/' || true
  rm -rf "$t"
}

# --no-backup-if-mismatch keeps .orig files out of $SKILLS_DIR; rejects still land as .rej and are
# swept by clean(). Returns non-zero on any reject so the caller can roll back.
replay_patch() {                    # $1 skill  $2 live-dir
  local pf; pf=$(patch_file "$1")
  [ -f "$pf" ] || return 0
  patch -p1 -s --no-backup-if-mismatch -d "$2" < "$pf"
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
    local pf; pf=$(patch_file "$skill")
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
        if [ "$n" -eq 0 ]; then
          state=identical; d=''
        elif [ ! -f "$pf" ]; then
          # A local edit with no patch is the one state that cannot survive a re-vendor. Upstream
          # has not moved, so nothing is lost yet - but it will be, silently, the day it does.
          state=unsnapshotted; d="$n diff lines, no patch - run --snapshot $skill"
        elif [ -n "$(diff -q <(gen_patch "$up" "$SKILLS_DIR/$skill") "$pf" 2>&1)" ]; then
          state=patch-stale;  d="local edits changed since snapshot - re-run --snapshot $skill"
        else
          state=local-only;   d="$n diff lines, upstream at baseline, patch current"
        fi
      else
        if [ "$n" -eq 0 ]; then
          state=upstream-changed; d="baseline ${base:0:12} -> ${sha:0:12}"
        elif [ -f "$pf" ]; then
          # Upstream moved onto an edited skill - appliable, because the patch replays the edit.
          # If upstream rewrote the same lines the replay rejects and --apply rolls back.
          state=upstream-changed; d="baseline ${base:0:12} -> ${sha:0:12}, local patch will replay"
        else
          state=both-changed;     d="$n diff lines, upstream moved to ${sha:0:12}, no patch"
        fi
      fi
    fi
    printf '%-32s %-6s %s\n' "$skill" "$r" "$state${d:+  $d}"
    case $state in
      upstream-changed)            appliable+=" $skill" ;;
      unsnapshotted|patch-stale)   review+=" $skill" ;;
      identical|local-only)        ;;
      *)                           blocked+=" $skill" ;;
    esac
  done < <(inventory_resolved)

  # local-only with a current patch is healthy and silent: the edit is captured, so a later
  # re-vendor replays it. REVIEW now means only "an edit exists that a re-vendor would lose".
  echo
  echo "APPLIABLE:${appliable:- none}      # --apply these after one confirmation"
  echo "REVIEW:${review:- none}      # local edits not captured in a patch - --snapshot them"
  echo "BLOCKED:${blocked:- none}      # upstream moved onto an uncaptured edit, or upstream gone"
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
  local live="$SKILLS_DIR/$skill" stage="$work/stage/$skill" backup="$work/backup/$skill" regime=no patched=''

  [ -d "$up" ]   || { echo "  $skill: upstream missing ($up)" >&2; return 1; }
  [ -d "$live" ] || { echo "  $skill: not vendored locally ($live)" >&2; return 1; }

  # `grep && regime=yes` would return non-zero for a skill with no regime line, which under set -e
  # aborts apply_one before it stages anything whenever it is called outside a condition.
  if grep -qE "$REGIME_RE *true" "$live/SKILL.md" 2>/dev/null; then regime=yes; fi

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

  # Replay the protected edits. A reject means upstream rewrote a line the local edit owns - the
  # one case that needs judgement - so restore the backup wholesale rather than leave a half-edited
  # skill and a .rej file for someone to find later.
  if [ -f "$(patch_file "$skill")" ]; then
    # patch reports rejects on stdout, so both streams go to the log or the reason is lost.
    if replay_patch "$skill" "$live" >"$work/patch.err" 2>&1; then
      patched=' +patch'
    else
      rm -rf "$live"; mv "$backup" "$live"
      echo "  $skill: local patch rejected, ROLLED BACK to the pre-apply copy" >&2
      sed 's/^/    /' "$work/patch.err" >&2
      echo "    upstream moved onto a protected edit - reconcile by hand, then --snapshot" >&2
      return 1
    fi
  fi
  echo "  $skill: written$([ "$regime" = yes ] && echo ' +regime')$patched" >&2
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
    # Interlock: a live diff with no patch is an edit the swap would destroy with no way to replay
    # it. Refuse rather than rely on the caller having read the BLOCKED list.
    if [ -n "$up" ] && [ ! -f "$(patch_file "$skill")" ] \
       && [ -n "$(drift_diff "$up" "$SKILLS_DIR/$skill")" ]; then
      echo "  $skill: refused - uncaptured local edits (run --snapshot $skill first)" >&2
      failed=$((failed + 1)); continue
    fi
    if apply_one "$skill" "$up" "$work"; then
      written=$((written + 1)); rebase+=("$skill=$sha")
    else
      failed=$((failed + 1))
    fi
  done

  # Only successful writes rebase: a rolled-back skill keeps its old baseline so the next --check
  # still reports it as needing attention.
  rebase_baselines "${rebase[@]+"${rebase[@]}"}"
  clean
  echo "written=$written failed=$failed baselines_rebased=${#rebase[@]}"
  [ "$written" -eq 0 ] \
    || echo "Regime line and protected edits replayed automatically. Re-run --check to confirm."
  [ "$failed" -eq 0 ] \
    || echo "Rolled-back skills keep their old baseline, so --check still reports them."
  [ "$failed" -eq 0 ]
}

# --- snapshot -------------------------------------------------------------------------------
# Capture a skill's current local edits as the patch a later re-vendor replays. Refuses while
# upstream is off-baseline: the diff there mixes the local edit with the upstream change, and
# snapshotting it would bake an upstream revert into the patch permanently.
snapshot() {
  local skill row up sha base n; local rc=0
  mkdir -p "$PATCHES"
  for skill in "$@"; do
    if ! row=$(lookup "$skill"); then
      echo "  $skill: not in inventory.tsv" >&2; rc=1; continue
    fi
    base=$(cut -f4 <<<"$row"); up=$(cut -f5 <<<"$row"); sha=$(cut -f6 <<<"$row")
    [ -n "$up" ] || { echo "  $skill: upstream missing" >&2; rc=1; continue; }
    if ! sha_same "$base" "$sha"; then
      echo "  $skill: refused - upstream moved to ${sha:0:12}; reconcile by hand first" >&2
      rc=1; continue
    fi
    if [ -z "$(drift_diff "$up" "$SKILLS_DIR/$skill")" ]; then
      rm -f "$(patch_file "$skill")"
      echo "  $skill: no local edits, patch removed"; continue
    fi
    gen_patch "$up" "$SKILLS_DIR/$skill" > "$(patch_file "$skill")"
    # Prove it replays before trusting it: a patch that does not reproduce the live tree is worse
    # than none, because --check would then read the skill as protected when it is not.
    if verify_patch "$skill" "$up"; then
      n=$(grep -c . "$(patch_file "$skill")" || true)
      echo "  $skill: snapshot written ($n lines), replay verified"
    else
      rm -f "$(patch_file "$skill")"
      echo "  $skill: snapshot did NOT replay cleanly, discarded" >&2; rc=1
    fi
  done
  return $rc
}

# Copy upstream, replay the patch, and require the result to equal the live tree.
verify_patch() {                    # $1 skill  $2 upstream
  local t ok=0; t=$(mktemp -d "${TMPDIR:-/tmp}/skills-resync-vfy-XXXXXX")
  cp -r "$2" "$t/x"
  replay_patch "$1" "$t/x" >/dev/null 2>&1 \
    && [ -z "$(diff -r --strip-trailing-cr -I "$REGIME_RE" "$t/x" "$SKILLS_DIR/$1")" ] || ok=1
  rm -rf "$t"
  return $ok
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
  # .regime sits at depth 2; patch rejects land beside the file they failed on, which for a
  # references/*.md edit is depth 3. Sweep to 4 so no nesting outruns this.
  while IFS= read -r p; do targets+=("$p"); done \
    < <(find "$SKILLS_DIR" -maxdepth 4 \( -name '*.regime' -o -name '*.rej' -o -name '*.orig' \) 2>/dev/null)
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
  PATCHES="$root/patches"; mkdir -p "$PATCHES"
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

  # --- protected edits replay across a re-vendor ------------------------------------------------
  # A local edit on a line upstream does not touch: the patch must carry it onto the new vendor.
  mkdir -p "$root/up2/demo" "$root/skills2/demo" "$root/work2" "$root/patches2"
  SKILLS_DIR="$root/skills2"; PATCHES="$root/patches2"
  # The two edits sit >3 lines apart so they land in separate hunks - adjacent ones would share
  # context lines and reject, which is the behaviour the rollback case below covers instead.
  # The local copy also carries L6, so this doubles as the regression guard for the two-owner bug:
  # restore_regime inserts the line, and if gen_patch had left it in the patch as well the replay
  # would find its own change already applied and reject a perfectly appliable re-vendor.
  demo_body() {                     # $1 first line  $2 last line  $3 non-empty for the regime line
    printf -- '---\nname: demo\n%s---\n%s\np\nq\nr\ns\nt\nu\n%s\n' "${3:+$REGIME$'\n'}" "$1" "$2"; }
  demo_body keep-me    tail-v1     > "$root/up2/demo/SKILL.md"
  demo_body LOCAL-EDIT tail-v1 yes > "$root/skills2/demo/SKILL.md"
  gen_patch "$root/up2/demo" "$root/skills2/demo" > "$PATCHES/demo.patch"
  verify_patch demo "$root/up2/demo" \
    || { echo "self-test FAIL: fresh snapshot does not replay" >&2; return 1; }

  demo_body keep-me tail-v2 > "$root/up2/demo/SKILL.md"
  apply_one demo "$root/up2/demo" "$root/work2" 2>/dev/null \
    || { echo "self-test FAIL: apply with a replayable patch failed" >&2; return 1; }
  grep -q '^LOCAL-EDIT$' "$root/skills2/demo/SKILL.md" \
    || { echo "self-test FAIL: protected edit lost across re-vendor" >&2; return 1; }
  grep -q '^tail-v2$' "$root/skills2/demo/SKILL.md" \
    || { echo "self-test FAIL: upstream change not taken" >&2; return 1; }
  [ "$(grep -c "^$REGIME\$" "$root/skills2/demo/SKILL.md")" = 1 ] \
    || { echo "self-test FAIL: regime line missing or duplicated alongside a patch" >&2; return 1; }
  grep -q 'disable-model-invocation' "$PATCHES/demo.patch" \
    && { echo "self-test FAIL: regime line leaked into the patch" >&2; return 1; }

  # --- a reject rolls back whole ----------------------------------------------------------------
  # Upstream rewrites the very line the patch owns. Nothing may be left half-applied.
  mkdir -p "$root/up3/demo" "$root/skills3/demo" "$root/work3" "$root/patches3"
  SKILLS_DIR="$root/skills3"; PATCHES="$root/patches3"
  printf -- '---\nname: demo\n---\na\nb\nc\nd\ne\nf\ng\n' > "$root/up3/demo/SKILL.md"
  printf -- '---\nname: demo\n---\na\nb\nc\nLOCAL\ne\nf\ng\n' > "$root/skills3/demo/SKILL.md"
  gen_patch "$root/up3/demo" "$root/skills3/demo" > "$PATCHES/demo.patch"
  printf -- '---\nname: demo\n---\nQ\nR\nS\nT\nU\nV\nW\n' > "$root/up3/demo/SKILL.md"
  if apply_one demo "$root/up3/demo" "$root/work3" 2>/dev/null; then
    echo "self-test FAIL: rejected patch reported success" >&2; return 1
  fi
  grep -q '^LOCAL$' "$root/skills3/demo/SKILL.md" \
    || { echo "self-test FAIL: rollback did not restore the local edit" >&2; return 1; }
  grep -q '^Q$' "$root/skills3/demo/SKILL.md" \
    && { echo "self-test FAIL: rollback left upstream content behind" >&2; return 1; }
  [ -z "$(find "$root/skills3" -name '*.rej' -o -name '*.orig' | grep . || true)" ] \
    || { echo "self-test FAIL: reject/backup files left in place" >&2; return 1; }

  echo "self-test OK"
}

usage() { sed -n '6,11p' "${BASH_SOURCE[0]}" | sed 's/^# \?//'; }

case "${1:---help}" in
  --check)     check ;;
  --diff)      [ $# -eq 2 ] || { usage; exit 2; }
               row=$(lookup "$2") || { echo "$2: not in inventory.tsv" >&2; exit 1; }
               up=$(cut -f5 <<<"$row")
               [ -n "$up" ] || { echo "$2: upstream missing" >&2; exit 1; }
               drift_diff "$up" "$SKILLS_DIR/$2" ;;
  --snapshot)  shift; [ $# -gt 0 ] || { usage; exit 2; }; snapshot "$@" ;;
  --apply)     shift; [ $# -gt 0 ] || { usage; exit 2; }; apply "$@" ;;
  --clean)     clean "${2:-}" ;;
  --self-test) self_test ;;
  *)           usage; exit 2 ;;
esac
