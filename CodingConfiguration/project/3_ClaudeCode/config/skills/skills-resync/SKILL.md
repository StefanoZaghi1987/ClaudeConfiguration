---
name: skills-resync
description: Check the vendored user skills in ~/.claude/skills against their upstream plugin copies and report drift. Manual maintenance task.
disable-model-invocation: true
allowed-tools: Bash, Read, Glob, Grep
---

These skills were copied out of plugins that are now disabled, so they receive no
marketplace updates. This task reports drift. Propose changes only — never overwrite a
vendored skill without explicit user confirmation.

## Vendored inventory

| Skill | Upstream plugin | Marketplace source |
|---|---|---|
| `interview-me` | `agent-skills` | `addyosmani/agent-skills` |
| `idea-refine` | `agent-skills` | `addyosmani/agent-skills` |
| `spec-driven-development` | `agent-skills` | `addyosmani/agent-skills` |
| `planning-and-task-breakdown` | `agent-skills` | `addyosmani/agent-skills` |
| `code-review-and-quality` | `agent-skills` | `addyosmani/agent-skills` |
| `documentation-and-adrs` | `agent-skills` | `addyosmani/agent-skills` |
| `doubt-driven-development` | `agent-skills` | `addyosmani/agent-skills` |
| `git-workflow-and-versioning` | `agent-skills` | `addyosmani/agent-skills` |
| `security-and-hardening` | `agent-skills` | `addyosmani/agent-skills` |
| `performance-optimization` | `agent-skills` | `addyosmani/agent-skills` |
| `grilling` | `mattpocock-skills` | `claude-plugins-official` |
| `diagnosing-bugs` | `mattpocock-skills` | `claude-plugins-official` |
| `wayfinder` | `mattpocock-skills` | `claude-plugins-official` |

Not vendored: `consolidate-comments`, `consolidate-specs`, `model-config-sync`, `skills-resync`
— these are original, have no upstream, and must never be reported as drifted.

## Procedure

1. For each vendored skill, locate the newest upstream copy under
   `~/.claude/plugins/cache/*/<plugin>/<version>/`, ignoring any path containing
   `.openclaw`, `.opencode`, `.codex-plugin`, `.cursor`, `.kimi`, `.devin`, `.qoder`.
2. Compare file-by-file against `~/.claude/skills/<skill>/`. Report per skill:
   `identical` · `upstream changed` · `local edits` · `both changed` · `upstream missing`.
3. Two local edits are deliberate and must be preserved on any re-vendor — re-apply them
   if you pull a new upstream copy:
   - `idea-refine/SKILL.md`: script path uses `${CLAUDE_SKILL_DIR}`, not a relative
     `skills/...` path, so it resolves at user scope.
   - `spec-driven-development/SKILL.md` Phase 4: points at `superpowers:*` skills, because
     the `agent-skills` skills it originally referenced are not vendored.
4. If the plugin cache has been swept, say so rather than guessing: re-enable the plugin
   briefly, or fetch the marketplace source, to obtain a comparison copy.
5. Report a table — skill, status, what changed — then wait for approval before writing.

Bare-name cross-references to non-vendored skills (`source-driven-development`,
`incremental-implementation`, `context-engineering`, `api-and-interface-design`,
`deprecation-and-migration`, `shipping-and-launch`, `debugging-and-error-recovery`,
`test-driven-development`) remain in some bodies as prose "see also" pointers. They are
inert and accepted. Flag them only if one becomes an executable instruction.

Recommended cadence: monthly, or when a skill behaves unexpectedly.
