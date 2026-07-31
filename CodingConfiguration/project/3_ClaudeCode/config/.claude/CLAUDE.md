# Workflow harness — regole di precedenza

## Catena primaria (workflow principale)
Spec → Plan → Task(Backlog MD) → Code(SDD) → Review → Doc. Una fase alla volta, con gate di approvazione bloccante dopo: spec (spec-reviewer), plan (implementation-plan-reviewer), implementazione (test green + review pulita).

## Skill primarie per fase (default)
- **F1 Brainstorming:** interview-me (ask vaghe) / idea-refine (variazioni) + agent `architect`
- **F2 Spec:** spec-driven-development + `architect`
- **F3 Spec review:** grilling (interattivo) + agent `spec-reviewer`
- **F4 Plan:** superpowers:writing-plans (+ planning-and-task-breakdown come rubric dep-graph/sizing) + `architect` (+ wayfinder se scope >1 sessione)
- **F5 Plan review:** agent `implementation-plan-reviewer` (+ doubt-driven-development se alta stake)
- **F6 Task:** planning-and-task-breakdown (logica) → MCP `backlog` (Backlog MD)
- **F7 Coding:** superpowers:using-git-worktrees (workspace) → superpowers:subagent-driven-development (consuma `docs/plans/<plan>.md`); executing-plans come fallback; ponytail come guardrail
- **F8 Review:** agent `code-reviewer` (locale) / code-review-and-quality (deep pre-merge) / code-review:code-review (PR GitHub cross-session)
- **F9 Doc:** documentation-and-adrs + consolidate-specs/comments + claude-md-management:claude-md-improver
- **F10 Ship:** superpowers:finishing-a-development-branch

## Fallback / priorità
- **Plan per SDD:** se non esiste `docs/plans/<plan>.md`, NON avviare SDD; torna a writing-plans.
- **Review:** default = agent `code-reviewer`; escalation a code-review-and-quality prima del merge; code-review:code-review solo su PR GitHub aperta.
- **Debug:** systematic-debugging (default, auto); per bug hard passa a diagnosing-bugs (feedback loop).
- **Navigazione codebase:** usa serena (MCP) per symbol-graph; wayfinder è planning, non navigazione.

## Quando NON usare planning mode
- Fix/attività breve (<1 modulo, <~100 righe): workflow semplificato (mini-piano in contesto, niente artefatti persistenti).
- Spec/plan già approvati e in esecuzione: resta in modalità esecuzione (SDD), non rientrare in planning.

## Quando i subagent sono ammessi
- Sempre in F7 (SDD: implementer + reviewer per task). Model selection: modello meno potente che regge il ruolo (mechanical=cheap, integration=standard, architecture=capable). Specifica sempre il model nel dispatch.
- In F8/F5/F3 solo se alta stake (doubt-driven: reviewer fresh-context + cross-model).
- Mai subagent di implementazione paralleli sullo stesso task (conflitto); paralleli OK per problemi indipendenti (dispatching-parallel-agents).

## Vincoli trasversali
- **Backlog MD è il system of record dei task:** ogni task ha cross-ref a SPEC § + Plan Task ID; ogni commit di implementazione ha footer `Plan-Task` + `Backlog-id`.
- **verification-before-completion:** nessun claim "fatto/funziona/passano" senza output comando fresco.
- **ponytail:** sui thread trust-boundary (validazione input, error-handling anti-data-loss, security, accessibilità) non semplificare MAI.
- **TDD vs ponytail:** test-first per logica non-triviale (branch/loop/parser/money/security); per one-liner trivial vale il self-check ponytail.
- **Riallineamento spec/doc:** SOLO via consolidate-specs/comments (con gate). Altre skill flaggano le divergenze, non le riscrivono. CLAUDE.md è gestito da claude-md-improver.
- **Navigazione:** "explore the codebase" significa usare serena come floor, non scan blanket grep.

## Regole globali in vigore
- `~/.claude/rules/documentation-lifecycle-rules.md` (flag, non rewrite; no-append sulle spec; comment policy).
- `~/.claude/rules/effort-escalation.md` (resta a effort default; raccomanda xhigh solo per debug multi-file / decisioni architetturali / security review / verification pass finale).
