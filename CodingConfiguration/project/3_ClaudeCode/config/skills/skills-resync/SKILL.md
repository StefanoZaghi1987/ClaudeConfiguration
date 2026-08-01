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
`~/.claude/plugins/cache/`; `<v>` is the newest version directory for that plugin.

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
copied only `SKILL.md`, which is why 17 dangling `references/*.md` pointers exist across the older
skills. Do not repeat that: for this group, `diff -rq` the whole directory, not just `SKILL.md`.

| Skill | Upstream plugin | Files | Note |
|---|---|---|---|
| `claude-automation-recommender` | `claude-code-setup` | 6 | 5 reference files |
| `skill-creator` | `skill-creator` | 18 | `agents/` ×3, `scripts/` ×9 (Python), `eval-viewer/`, `assets/`, 1 reference |
| `build-mcp-server` | `mcp-server-dev` | 9 | 8 reference files |
| `build-mcp-app` | `mcp-server-dev` | 7 | 6 reference files; local edit **L8** |
| `build-mcpb` | `mcp-server-dev` | 3 | 2 reference files; local edit **L8** |

All five carry `disable-model-invocation: true`, added at vendor time and **not present upstream**.
Re-apply it after any re-vendor: without it each one costs its description in every turn, which is
the reason the plugins were disabled in the first place.

**The three `build-mcp-*` skills are one unit — never vendor a subset.** They cross-reference each
other with sibling-relative paths (`../build-mcp-server/references/elicitation.md` in
`build-mcp-app/SKILL.md`). That path resolves only while all three sit as siblings under
`~/.claude/skills/`. Vendoring one alone breaks it silently.

Upstream version to read: the `installPath` recorded in `installed_plugins.json`, which for
`mcp-server-dev` is the `unknown` directory. Several sha-named sibling directories hold older
copies of the same plugin; ignore them.

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
- **L8** — `build-mcp-app/references/widget-templates.md` and
  `build-mcpb/references/local-security.md`: three pointers were changed from
  `../build-mcp-server/…` to `../../build-mcp-server/…`. **These were broken upstream**, not by
  vendoring — written as if resolving from the skill root while sitting inside `references/`. A
  re-vendor reintroduces the upstream bug. Confirm with
  `grep -rn '\.\./build-mcp-server/' ~/.claude/skills/build-mcp-app/references ~/.claude/skills/build-mcpb/references`
  returning nothing. The same string in `build-mcp-app/SKILL.md` is correct and must be left alone.
- **L9 — the invocation regime is local state, never upstream state.** Fourteen skills carry
  `disable-model-invocation: true` that their upstream does not have. The line is a **functional
  dependency, not a preference**: without it the skill pays its description in every turn, and the
  trigger collisions that `~/.claude/CLAUDE.md` exists to resolve come back — including a four-way
  collision on the first message of a new feature between `interview-me`, `idea-refine`,
  `wayfinder` and `grilling`.

  Nine of them were demoted from an upstream that is model-invoked, on 2026-08-01:

  `brainstorming` · `code-simplification` · `context-engineering` ·
  `dispatching-parallel-agents` · `doubt-driven-development` · `idea-refine` ·
  `incremental-implementation` · `interview-me` · `systematic-debugging`

  The other five are the vendored plugin group above: `claude-automation-recommender` ·
  `skill-creator` · `build-mcp-server` · `build-mcp-app` · `build-mcpb`.

  On `idea-refine` and `systematic-debugging` this edit sits **alongside** L1 and L3 respectively;
  a diff confined to L9 plus those is still `identical`.

  Do not maintain this list by hand — it goes stale the moment a skill is promoted or demoted.
  Reconstruct it before any re-vendor, and verify it afterwards, with the regime itself as the
  source of truth:

  ```
  # every locally slash-only skill whose upstream is not
  for s in ~/.claude/skills/*/SKILL.md; do
    grep -ql '^disable-model-invocation: *true' "$s" && echo "$(basename $(dirname $s))"
  done
  ```

  A re-vendor that drops the line reports success while silently reverting a deliberate decision:
  `cp` exits 0, the skill works, and only the token bill and the non-deterministic trigger show it.
  This is the edit most likely to be lost, because it is one line and looks like metadata.

## Procedure — detect

1. For each vendored skill, resolve the newest upstream directory from its table row,
   ignoring any path containing `.openclaw`, `.opencode`, `.codex-plugin`, `.cursor`,
   `.kimi`, `.devin`, `.qoder`.
2. `diff -rq <upstream> ~/.claude/skills/<skill>` and classify:
   `identical` · `upstream changed` · `local edits` · `both changed` · `upstream missing`.
   For any skill with a protected local edit, a diff confined to its protected edits is `identical`.
3. If a plugin's cache has been swept, say so rather than guessing — re-enable the plugin
   briefly, or fetch the marketplace source, to get a comparison copy. Never treat a
   missing upstream as "no drift".
4. Report one table — skill, status, what changed — and stop. Classify every skill as
   **auto-appliable** (`upstream changed`, or `both changed` where the local side is only
   its protected edits), **no action** (`identical`, or `local edits` — upstream has not moved, so
   there is nothing to re-vendor), or **blocked** (`both changed` with an undocumented local edit,
   `upstream missing`). Show the undocumented local diff inline for each blocked skill.

   A skill sitting in **no action** because of `local edits` is not settled, only quiet: the moment
   upstream moves it becomes `both changed`, and whether it lands in auto-appliable or blocked
   depends entirely on whether its local edit is documented above. Check that the edit is listed
   before moving on, rather than when the plugin next updates.

## Procedure — apply

5. Ask **once**, for the whole auto-appliable set: list the skill names and ask to
   re-vendor them all. Accept a subset if the user names one. Blocked skills are never
   included — resolve those one at a time, by hand.
6. On confirmation, for each approved skill:
   - back up: `cp -r ~/.claude/skills/<skill> "$TMPDIR/skills-resync-backup/<skill>"`
   - `rm -rf ~/.claude/skills/<skill>` then `cp -r <upstream> ~/.claude/skills/<skill>`
     (replace, do not merge — a stale file left behind by an upstream deletion is drift
     that no later diff will catch)
   - re-apply the skill's protected local edits (L1–L4) per the table
7. Verify before reporting: re-run step 2 on every written skill. Expect `identical`, or a
   diff confined to its protected edits. Anything else — restore that skill from the backup and report
   the failure. Do not report success from the fact that `cp` exited 0.
8. Report what was written, what was skipped, and what is still blocked.

Bare-name cross-references to non-vendored skills (`source-driven-development`,
`api-and-interface-design`, `deprecation-and-migration`, `shipping-and-launch`,
`debugging-and-error-recovery`, `test-driven-development`) remain in some bodies as prose
"see also" pointers. They are inert and accepted. Flag one only if it becomes an
executable instruction.

Recommended cadence: monthly, or when a skill behaves unexpectedly.
