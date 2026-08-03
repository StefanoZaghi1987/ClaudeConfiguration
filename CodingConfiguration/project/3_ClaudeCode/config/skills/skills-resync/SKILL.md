---
name: skills-resync
description: Check the vendored user skills in ~/.claude/skills against their upstream plugin copies, report drift, and — after one explicit confirmation — re-vendor every approved skill automatically. Manual maintenance task.
disable-model-invocation: true
allowed-tools: Bash, Read, Glob, Grep, Edit, Write
---

These skills were copied out of their plugins so they survive the plugin being disabled,
updated, or swept. They receive no marketplace updates. This task reports drift, then
applies it on confirmation. Never write before the user confirms.

## Vendored inventory

Grouped by upstream plugin, alphabetical within each group. Cache root is
`~/.claude/plugins/cache/`; `<v>` is the version directory recorded below.

### Vendored-from baseline

A two-way `diff` cannot tell *upstream moved* from *someone edited locally* — both render as a
difference, and the classification in step 4 turns on which it is. These are the versions each group
was vendored from, which makes the question decidable without keeping a copy of the old upstream:

| Group | Version | `gitCommitSha` |
|---|---|---|
| `agent-skills` | `7829ffd90d97` | `7829ffd90d97` |
| `mattpocock-skills` | `1.2.0` | `2ab958093e83` |
| `superpowers` | `6.2.0` | `917e5f53b16b` |
| `claude-code-setup` | `1.0.0` | `2cd88e7947b7` |
| `skill-creator` | `unknown` | `20a5a1f1a2b5` |
| `mcp-server-dev` | `unknown` | `20a5a1f1a2b5` |

`skill-creator` and `mcp-server-dev` both record `unknown` as their version, so for those two the sha
is the only usable identifier — which is also why "newest version directory" is the wrong rule for
them and this table is authoritative over any directory listing.

**Update this table in the same commit as any re-vendor.** A stale baseline is worse than none: it
reports upstream as moved when it has not, and sends healthy skills to `blocked`.

### `agent-skills` — `addy-agent-skills/agent-skills/<v>/skills/<skill>/` (plugin disabled)

| Skill | Note |
|---|---|
| `code-review-and-quality` | |
| `code-simplification` | |
| `context-engineering` | |
| `documentation-and-adrs` | |
| `doubt-driven-development` | |
| `idea-refine` | local edit L1 |
| `incremental-implementation` | |
| `interview-me` | |
| `planning-and-task-breakdown` | |
| `security-and-hardening` | |
| `spec-driven-development` | local edit L2 |

### `mattpocock-skills` — `claude-plugins-official/mattpocock-skills/<v>/skills/<category>/<skill>/` (plugin disabled)

| Skill | Category |
|---|---|
| `diagnosing-bugs` | `engineering` |
| `grilling` | `productivity` |
| `handoff` | `productivity` |
| `wayfinder` | `engineering` |
| `writing-great-skills` | `productivity` |

### `superpowers` — `claude-plugins-official/superpowers/<v>/skills/<skill>/` (plugin disabled)

| Skill | Note |
|---|---|
| `brainstorming` | |
| `dispatching-parallel-agents` | |
| `executing-plans` | local edit L3 |
| `subagent-driven-development` | local edit L3, L4 |
| `systematic-debugging` | local edit L3 |
| `writing-plans` | local edit L3 |

Only 6 of the plugin's 14 skills are vendored. The other 8 — including
`using-git-worktrees`, `finishing-a-development-branch`, `test-driven-development`,
`verification-before-completion`, `requesting-code-review` and `using-superpowers` — were
deliberately dropped, not overlooked. Do not vendor them back in to "fix" L3.

### `claude-code-setup`, `skill-creator`, `mcp-server-dev` — `claude-plugins-official/<plugin>/<v>/skills/<skill>/` (plugins disabled 2026-08-01)

Vendored **with their `references/` directories**, unlike every group above — the earlier vendoring
copied only `SKILL.md`, which is why six dangling `references/*.md` pointers survive in the
`agent-skills` group: `performance-checklist.md` and `security-checklist.md` in
`code-review-and-quality`, `security-checklist.md` in `security-and-hardening`,
`orchestration-patterns.md` in `doubt-driven-development`, and `definition-of-done.md` in both
`incremental-implementation` and `planning-and-task-breakdown`. They are inert, and `~/.claude/CLAUDE.md`
already rules on them: say so and continue, never invent the contents. Do not repeat that vendoring
mistake — for this group, `diff -rq` the whole directory, not just `SKILL.md`.

| Skill | Upstream plugin | Files | Note |
|---|---|---|---|
| `claude-automation-recommender` | `claude-code-setup` | 6 | 5 reference files |
| `skill-creator` | `skill-creator` | 18 | `agents/` ×3, `scripts/` ×9 (Python), `eval-viewer/`, `assets/`, 1 reference |
| `build-mcp-server` | `mcp-server-dev` | 9 | 8 reference files |
| `build-mcp-app` | `mcp-server-dev` | 7 | 6 reference files; local edit **L5** |
| `build-mcpb` | `mcp-server-dev` | 3 | 2 reference files; local edit **L5** |

All five carry the L6 flag.

**The three `build-mcp-*` skills are one unit — never vendor a subset.** They cross-reference each
other with sibling-relative paths (`../build-mcp-server/references/elicitation.md` in
`build-mcp-app/SKILL.md`). That path resolves only while all three sit as siblings under
`~/.claude/skills/`. Vendoring one alone breaks it silently.

Both plugins keep sha-named sibling directories holding older copies; ignore them and use the
baseline table's version directory.

### `code-review` — a command, not a skill

The `code-review` plugin ships no skill. Its `commands/code-review.md` was copied to
`~/.claude/commands/code-review.md` with `disable-model-invocation` flipped from `false` to `true`.
It is not part of the skills inventory and `diff -rq` over `~/.claude/skills` will never see it —
check it by hand, or leave it alone: it is a PR-review workflow over `gh`, and the `code-reviewer`
subagent covers the same ground for a working diff.

### `ponytail` — deliberately not vendored, plugin kept **enabled**

`ponytail@ponytail` is the one upstream plugin left enabled, so nothing from it is
vendored and nothing from it belongs in the table above. Its value is almost entirely
outside the skill files: the SessionStart mode hook, the `lite`/`full`/`ultra` mode
tracker, the statusline, subagent propagation, and six `/ponytail*` commands. None of that
survives copying a `SKILL.md` into `~/.claude/skills/`. `ponytail-review` was vendored once
and removed again — while the plugin is on, a vendored copy only duplicates a skill already
provided, and `/ponytail-review` would still come from the plugin either way.

If ponytail is ever disabled, vendor from `ponytail/ponytail/<v>/skills/<skill>/` and add a
section here. Until then, do not report ponytail as missing or drifted.

Not vendored: `consolidate-comments`, `consolidate-specs`, `model-config-sync`,
`skills-resync` — original, no upstream, never report them as drifted.

## Protected local edits

Re-apply these after any re-vendor; verify each is present before reporting success. Verify
by reading the file on disk, never by comparing against this skill's text as it arrives in
context — the harness expands `${...}` before injecting it, so L1's `${CLAUDE_SKILL_DIR}`
reads there as an expanded literal path and an intact file looks divergent.

- **L1** — `idea-refine/SKILL.md`: script path uses `${CLAUDE_SKILL_DIR}`, not a relative
  `skills/...` path, so it resolves at user scope.
- **L2** — `spec-driven-development/SKILL.md` Phase 4: points at `superpowers:*` skills,
  because the `agent-skills` skills it originally referenced are not vendored.
- **L3** — the four superpowers skills above carry no `superpowers:` prefixes and no
  `../<skill>/` paths. Upstream, 16 references pointed at sibling plugin skills; 5 resolved
  to skills vendored here and were reduced to bare names, and 11 pointed at the 8 skills
  that were dropped and were rewritten into plain instructions. A re-vendor reintroduces
  all 16 as dangling references — several tagged `REQUIRED SUB-SKILL`, so they are
  executable, not prose. Re-apply by re-running the rewrite, then confirm
  `grep -rn 'superpowers:\|\.\./[a-z-]*/' ` over the four skills returns nothing.
- **L4** — `subagent-driven-development/code-reviewer.md` is a vendored copy of
  `requesting-code-review/code-reviewer.md`, and the 4 links to it were repointed from
  `../requesting-code-review/` to `./`. The skill dispatches its final reviewer with this
  file, so it is a functional dependency, not a citation. Re-copy it on any re-vendor.
- **L5** — `build-mcp-app/references/widget-templates.md` and
  `build-mcpb/references/local-security.md`: three pointers were changed from
  `../build-mcp-server/…` to `../../build-mcp-server/…`. **These were broken upstream**, not by
  vendoring — written as if resolving from the skill root while sitting inside `references/`. A
  re-vendor reintroduces the upstream bug. Confirm with a **lookbehind**, which the obvious pattern
  gets wrong — `\.\./build-mcp-server/` is a substring of the corrected `../../build-mcp-server/`, so
  it matches the fix itself and reports L5 as lost every time:

  ```
  grep -rnP '(?<!\.\./)\.\./build-mcp-server/' \
    ~/.claude/skills/build-mcp-app/references ~/.claude/skills/build-mcpb/references
  ```

  Nothing returned means intact; there should be exactly three `../../build-mcp-server/` pointers
  across the two files. The same string in `build-mcp-app/SKILL.md` is correct and must be left alone.
- **L6 — the invocation regime is local state, never upstream state.** Eleven skills carry
  `disable-model-invocation: true` that their upstream does not have. The line is a **functional
  dependency, not a preference**: without it the skill pays its description in every turn, and the
  trigger collisions that `~/.claude/CLAUDE.md` exists to resolve come back — `idea-refine` and
  `brainstorming` both firing on a formless idea, on top of `interview-me` and `grilling`, which are
  model-invoked by design and already overlap on "stress-test my thinking".

  Six were demoted from an upstream that is model-invoked, on 2026-08-01:

  `brainstorming` · `context-engineering` · `dispatching-parallel-agents` ·
  `doubt-driven-development` · `idea-refine` · `systematic-debugging`

  The other five are the vendored plugin group above: `claude-automation-recommender` ·
  `skill-creator` · `build-mcp-server` · `build-mcp-app` · `build-mcpb`.

  On `idea-refine` and `systematic-debugging` this edit sits **alongside** L1 and L3 respectively;
  a diff confined to L6 plus those is still `identical`.

  **Two classes look like a lost L6 edit and are not. Do not "restore" either.**

  *Promoted back to model-invoked on 2026-08-03* — `code-simplification` ·
  `incremental-implementation` · `interview-me`. Deliberate: they are wanted as always-active. All
  three are now **byte-identical to upstream**, so they carry no protected edit at all and a
  re-vendor is a plain copy. An absent flag here is the intended state.

  *Flagged upstream already* — `wayfinder` · `handoff` · `writing-great-skills`. Upstream ships the
  line itself, so it is not a local edit: neither re-add it as one nor strip it. These three are also
  byte-identical to upstream.

  Do not maintain the eleven by hand — the list goes stale the moment a skill is promoted or demoted.
  Reconstruct it before any re-vendor, and verify it afterwards, with the regime itself as the
  source of truth:

  ```
  # every locally slash-only skill, whatever the reason
  for s in ~/.claude/skills/*/SKILL.md; do
    grep -ql '^disable-model-invocation: *true' "$s" && echo "$(basename $(dirname $s))"
  done
  ```

  That prints **18**, not eleven, and the difference is not drift:
  **18 = 11 locally added + 3 flagged upstream + 4 originals with no upstream.** Reconcile against
  that identity before concluding anything is missing; a count that lands on 18 is healthy.

  A re-vendor that drops the line reports success while silently reverting a deliberate decision:
  `cp` exits 0, the skill works, and only the token bill and the non-deterministic trigger show it.
  This is the edit most likely to be lost, because it is one line and looks like metadata.

## Procedure — detect

1. **First, per group, compare the baseline sha against `installed_plugins.json`'s `gitCommitSha`.**
   Unchanged means upstream has not moved, so every difference step 2 finds is local by elimination.
   Changed means upstream moved, and the new sha is what the table becomes after the re-vendor. Do
   this before diffing: it is the only input that makes a difference interpretable, and skipping it
   turns step 4 into a guess.

   Then resolve each skill's upstream directory from its table row, ignoring any path containing
   `.openclaw`, `.opencode`, `.codex-plugin`, `.cursor`, `.kimi`, `.devin`, `.qoder` — those are other
   agents' vendored copies living inside the same repos.
2. `diff -rq --strip-trailing-cr <upstream> ~/.claude/skills/<skill>` and classify:
   `identical` · `upstream changed` · `local edits` · `both changed` · `upstream missing`.
   For any skill with a protected local edit, a diff confined to its protected edits is `identical`.

   **`--strip-trailing-cr` is not optional.** Eleven local skills were rewritten by a Windows editor
   when their L6 line was added, so they are CRLF against LF upstream. Without the flag every line
   reads as changed: `skill-creator` shows a 974-line diff whose real content is 3, `build-mcp-app`
   793 against 8. The `-q` verdict is `differ` either way — what the flag rescues is the *content*,
   and with it every one of the eleven collapses to exactly its documented edits. Judging
   "protected edits only" from the unstripped diff is impossible, so the skill lands in `blocked` and
   never updates. Use the flag on every diff in this document, quiet or not.
3. If a plugin's cache has been swept, say so rather than guessing — re-enable the plugin
   briefly, or fetch the marketplace source, to get a comparison copy. Never treat a
   missing upstream as "no drift".
4. Report one table — skill, status, what changed — and stop. The two inputs decide it jointly: the
   sha from step 1 says whether upstream moved, the diff from step 2 says whether anything beyond the
   documented edits is present.

   | sha | diff beyond documented edits | State | Action |
   |---|---|---|---|
   | unchanged | none | `identical` | none |
   | unchanged | present | `local edits` — undocumented, by elimination | **blocked** |
   | changed | none | `upstream changed` | **auto-appliable** |
   | changed | present | `both changed` | **blocked** |
   | — | — | `upstream missing` | **blocked** |

   Show the undocumented diff inline for each blocked skill. Never infer the state from diff size
   alone: a large diff on an unmoved sha is a local edit, and a small one on a moved sha is still an
   upstream change.

   The protected-edit list is what makes this table work, so an edit made and not documented now
   surfaces immediately as `local edits` → blocked rather than lying dormant until the plugin next
   updates. That is the intended direction of failure: loud, and at the time the edit was made.

## Procedure — apply

5. Ask **once**, for the whole auto-appliable set: list the skill names and ask to
   re-vendor them all. Accept a subset if the user names one. Blocked skills are never
   included — resolve those one at a time, by hand.
6. On confirmation, run `scripts/resync-apply.sh <skill>=<upstream-dir> …`, passing one pair per
   approved skill with the path resolved in step 1. It owns the mechanical sequence: stage a copy from
   upstream, verify the staged copy, back up the live directory, then swap. Replacement is wholesale,
   not a merge — a stale file left behind by an upstream deletion is drift no later diff will catch —
   and because nothing under `~/.claude/skills` is touched until a verified copy exists, a failed copy
   cannot leave a skill half-written. It takes an explicit list and never discovers its own work.

   Upstream paths are arguments rather than logic inside the script, so the inventory table stays the
   single source of truth and no hardcoded version directory can rot.

   The backup lives in a `mktemp -d` directory removed by an `EXIT` trap, so it is gone on success, on
   failure and on interrupt alike. Do not hand-roll this with `$TMPDIR`: that variable is unset under
   Git Bash, so the old `"$TMPDIR/skills-resync-backup/<skill>"` wrote to the mount root and stayed
   there. `scripts/resync-apply.sh --self-test` checks the replace, stale-file and missing-upstream
   paths in a scratch directory, touching nothing real.
7. Re-apply each skill's protected local edits (L1–L6) by hand — the script deliberately does not,
   because L3's reference rewrite is a judgement call. Then re-run step 2 on every written skill and
   expect `identical`, or a diff confined to its protected edits. Do not report success from the fact
   that `cp` exited 0.

   Now write the new sha into the **Vendored-from baseline** table for every group re-vendored, in this
   same pass. Left until later it never happens, and the next run then reports every one of those
   skills as `upstream changed` and re-vendors them again.
8. Report what was written, what was skipped, and what is still blocked. The script's own temp
   directory needs no cleanup — its trap already handled it — so what remains is to sweep leftovers
   this task did not create, and report rather than delete: orphaned marketplace clones at
   `~/.claude/plugins/cache/temp_git_*` (15 of them, roughly 36 MB as of 2026-08-03), stale
   `/tmp/tmp.*` directories, and `/skills-resync-backup` at the Git Bash mount root if an older copy
   of this skill ever ran with the `$TMPDIR` bug. Give the total size and offer deletion as a separate
   confirmed step; never fold it into a re-vendor.

Bare-name cross-references to non-vendored skills (`source-driven-development`,
`api-and-interface-design`, `deprecation-and-migration`, `shipping-and-launch`,
`debugging-and-error-recovery`, `test-driven-development`) remain in some bodies as prose
"see also" pointers. They are inert and accepted. Flag one only if it becomes an
executable instruction.

Recommended cadence: monthly, or when a skill behaves unexpectedly.
