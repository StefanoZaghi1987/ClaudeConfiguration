# 30 — Conflitti e sovrapposizioni (Fase 3)

> Per ogni zona di collisione: sovrapposizione, chi vince (secondo v3 confermata), come si risolve (azione concreta). Poi conflitti di direttiva (imperativi che si contraddicono), trigger ambigui, ridondanze di costo.
>
> **v3 (composizione confermata)** è l'arbitro: ciò che v3 elegge a primario vince; il resto viene disarmato via disabilitazione/restringimento trigger/regola CLAUDE.md.

---

## 1. Matrice di collisione

### Cluster SPEC (F2)
| Coppia | Sovrapposizione | Vince (v3) | Risoluzione |
|---|---|---|---|
| `spec-driven-development` vs `superpowers:brainstorming` | entrambi producono un documento di specifica/design | `spec-driven-development` (F2) | brainstorming → on-demand/hard-gate opzionale; **unificare il path**: SPEC in `docs/specs/<feature>.md` (regola CLAUDE.md), non `docs/superpowers/specs/` vs `SPEC.md` root |
| `spec-driven-development` vs `mattpocock:to-spec` | entrambi scrivono una spec | `spec-driven-development` | to-spec → solo se si pubblica su tracker/Backlog MD (sintesi, no interview); regola: "spec locale = spec-driven-development; spec→tracker = to-spec" |

### Cluster PLAN (F4)
| Coppia | Sovrapposizione | Vince | Risoluzione |
|---|---|---|---|
| `writing-plans` vs `planning-and-task-breakdown` | entrambi producono un piano | `writing-plans` (F4, input per SDD) | planning-and-task-breakdown → **solo rubric** (dep-graph/vertical-slicing/sizing) + F6; **non produce tasks/plan.md** nel workflow target (regola CLAUDE.md) |
| `writing-plans` vs `wayfinder` | entrambi pianificano | `writing-plans` (default) | wayfinder → **solo scope >1 sessione** (regola: "wayfinder se il piano non sta in un contesto") |

### Cluster TASK (F6)
| Coppia | Sovrapposizione | Vince | Risoluzione |
|---|---|---|---|
| `planning-and-task-breakdown` (tasks/todo.md) vs `mattpocock:to-tickets` (.scratch/issues/) vs Backlog MD | 3 formati di task diversi | **Backlog MD** (SoR) | planning-and-task-breakdown/to-tickets → **logica di decomposizione alimentata IN Backlog MD** via `/backlog-sync`; nessun file tasks/ o .scratch/ nel workflow target |

### Cluster CODING/ESECUZIONE (F7)
| Coppia | Sovrapposizione | Vince | Risoluzione |
|---|---|---|---|
| `subagent-driven-development` vs `executing-plans` | entrambi eseguono un piano | SDD (default) | executing-plans → fallback quando non ci sono subagent; regola: "SDD se subagent disponibili, altrimenti executing-plans" |
| SDD vs `dispatching-parallel-agents` | entrambi orchestrano subagent | SDD (per-task sequenziale) | dispatching-parallel → **solo problemi indipendenti** (F10 debug), mai su task dello stesso piano (conflitto file) |
| `superpowers:test-driven-development` vs `agent-skills:test-driven-development` vs `mattpocock:tdd` | 3 TDD | superpowers:TDD (compone con writing-plans/SDD) | agent-skills:TDD come riferimento pragmatico; mattpocock:tdd on-demand; v3 li tiene **encodeati** nel plan + superpowers:TDD come disciplina |

### Cluster CODE REVIEW (F8) — la zona più affollata
| Entità | Sovrapposizione | Vince (v3) | Risoluzione |
|---|---|---|---|
| `code-reviewer` (agent user) | review diff locale | **default locale** | — |
| `agent-skills:code-review-and-quality` | review diff locale (5-assi) | **deep pre-merge** | escalation dal default |
| `code-review:code-review` (cmd) | review PR GitHub | **cross-session PR** | solo su PR aperta |
| `mattpocock:code-review` | review diff (2-assi) | on-demand | — |
| `superpowers:requesting-code-review` | meccanismo dispatch | interno a SDD | — |
| `feature-dev:code-reviewer` (agent) | review diff | **DISABILITA** (feature-dev off) | duplicato del code-reviewer user-level |
| `agent-skills:code-reviewer` (agent) | review diff (5-dim) | on-demand | duplicato funzionale di code-review-and-quality; keep ma non default |

### Cluster DEBUG (F10)
| Coppia | Sovrapposizione | Vince | Risoluzione |
|---|---|---|---|
| `systematic-debugging` vs `debugging-and-error-recovery` vs `diagnosing-bugs` | 3 processi di debug | systematic-debugging (default, auto-trigger) | diagnosing-bugs per bug hard (feedback loop); debugging-and-error-recovery come checklist/Stop-the-Line on-demand |

### Cluster BRAINSTORM/INTERROGATION (F1)
| Coppia | Sovrapposizione | Vince | Risoluzione |
|---|---|---|---|
| `interview-me` vs `idea-refine` vs `grilling` vs `brainstorming` | 4 modalità di dialogo/ideazione | interview-me (ask vaghe) + idea-refine (variazioni) | grilling → F3 stress-test; brainstorming → hard-gate opzionale; **regola di fase** per disambiguare (§3 trigger) |

### Cluster SIMPLIFY (F10)
| Coppia | Sovrapposizione | Vince | Risoluzione |
|---|---|---|---|
| `agent-skills:code-simplification` vs `code-simplifier` (agent) vs `ponytail-review` | 3 simplifier | code-simplification + ponytail-review (v3) | **code-simplifier DISABILITA** (duplicato); ponytail-review per over-engineering puro |

---

## 2. Conflitti di direttiva (imperativi che si contraddicono)

| # | Conflitto | Skill in causa | Prevalenza | Regola scritta che la garantisce |
|---|---|---|---|---|
| D1 | **"Esplora esaustivamente il codebase" vs "Parti dal knowledge graph"** *(esattamente il tuo esempio)* | brainstorming/architect/spec-driven-development/systematic-debugging ("explore/read completely") **vs** consolidate-specs/comments ("floor = knowledge graph; blanket scope è il failure mode") | **serena come floor**; le skill "explore" si appoggiano a serena (symbol-graph) invece di grep esaustivo | CLAUDE.md: "Navigazione/comprensione codebase via serena. Le skill che dicono 'explore the codebase' usano serena come floor, non scan blanket." |
| D2 | **TDD "NO PRODUCTION CODE WITHOUT FAILING TEST" vs ponytail "trivial one-liners need no test, YAGNI applies to tests too"** | superpowers:test-driven-development (Iron Law, tutto) **vs** ponytail (esente one-liner) | **Per logica non-triviale** (branch/loop/parser/money/security): vince TDD (test-first). **Per one-liner trivial**: vince ponytail (self-check `demo()`/`assert` basta) | CLAUDE.md: "Test-first per logica non-triviale; per one-liner trivial vale il self-check ponytail. Mai saltare il test su thread trust-boundary." |
| D3 | **"Flag, don't rewrite" vs riscrittura spec/CLAUDE.md** | documentation-lifecycle-rules ("Never resolve a divergence yourself; flag") **vs** consolidate-specs/comments + claude-md-improver (riscrivono) | **consolidate-\* è il solo meccanismo sanzionato** di riallineamento spec/doc (con gate/tier/intake); claude-md-improver riscrive **CLAUDE.md** (config, non spec) → consentito; **ogni altra riscrittura ad-hoc di spec/doc è vietata** (si flagga) | CLAUDE.md: "Riallineamento spec/design doc SOLO via consolidate-* (con gate). Altre skill flaggano le divergenze, non le riscrivono. CLAUDE.md è gestito da claude-md-improver." |
| D4 | **"Continuous execution, no check-in between tasks" vs "one question at a time, wait"** | subagent-driven-development (no pause tra task) **vs** interview-me/brainstorming/grilling (una-domanda-per-volta) | **Phase-scoping**: SDD = F7 esecuzione (no pause); interview/grilling = F1/F3 dialogo. using-superpowers "invoke skill prima di ogni risposta" non deve innescare dialogo mid-SDD | CLAUDE.md: "Le regole 'una domanda alla volta' valgono in F1/F3 (dialogo). In F7 (SDD) vale 'continuous execution'; il controller non fa check-in tra task." |
| D5 | **"MUST invoke skills before ANY response" vs efficienza/shortest-path** | using-superpowers (EXTREMELY_IMPORTANT, skill-check ogni turno) **vs** ponytail (shortest diff, no overhead) | using-superpowers è il **loader** (non disabilitabile facilmente); ponytail governa **cosa costruire**, non il check. Tensione assorbita da phase-scoping + ponytail-lite default | CLAUDE.md + ponytail-lite (mitiga costo every-turn di using-superpowers) |

---

## 3. Trigger ambigui (description simili → scelta non deterministica)

Per ognuno: il trigger ambiguo e la **regola di fase/scope** che la rende deterministica (da CLAUDE.md).

| Trigger utente | Skill che competono (auto-trigger) | Regola di disambiguazione |
|---|---|---|
| "stress-test my thinking/plan/idea", "grill me", "are we sure?" | interview-me, idea-refine, grilling, doubt-driven-development | **Per fase**: pre-spec (F1) → interview-me/idea-refine; review spec/plan (F3/F5) → grilling (interattivo) / doubt-driven (alta stake, adversarial) |
| "review this", "code review" | code-reviewer (agent), code-review-and-quality, mattpocock:code-review, code-review cmd, requesting-code-review | **Per scope**: diff locale default → code-reviewer; deep pre-merge → code-review-and-quality; PR GitHub aperta → code-review cmd |
| "debug this", "diagnose", "why is X broken/slow" | systematic-debugging, debugging-and-error-recovery, diagnosing-bugs | systematic-debugging (default); se bug hard/non-ripetibile → diagnosing-bugs (feedback loop) |
| "plan this", "break this down" | writing-plans, planning-and-task-breakdown, wayfinder | writing-plans (default, produce input SDD); scope>1 sessione → wayfinder; solo decomposizione→Backlog MD → planning-and-task-breakdown (F6) |
| "write tests", "TDD" | superpowers:test-driven-development, agent-skills:test-driven-development, mattpocock:tdd, /test | superpowers:test-driven-development (compone con plan/SDD); /test shortcut |
| "simplify this", "clean up" | code-simplification, code-simplifier, ponytail-review | code-simplification (chiarezza); over-engineering puro → ponytail-review (code-simplifier disabilitato) |
| "navigate/understand the codebase", "where is X" | serena (MCP), wayfinder, context-engineering | serena (symbol-graph nav); wayfinder è planning; context-engineering per setup regole |

---

## 4. Ridondanze di costo (stesso contesto ricaricato in punti diversi)

| Ridondanza | Dove | Impatto | Mitigazione |
|---|---|---|---|
| **4 agent review ri-raccogliono il codebase da zero** (architect → spec-reviewer → plan-reviewer → code-reviewer), ognuno con contesto isolato | F2→F3→F5→F8 | 4× context gathering per feature | sono **scoped** (architect=area design; reviewer=artifact+spot-check "read only what you need"), ma resta la ridondanza. Mitiga: alimentarli con i cross-ref (SPEC §, Plan Task, SHAs) invece di farli riscoprire |
| **SDD: ogni implementer/reviewer subagent ri-raccoglie** | F7 | ×N task | by design; il **ledger** + i **brief/report file** (non paste in contesto) mitigano; model-selection riduce costo |
| **doubt-driven: fresh-context reviewer + cross-model CLI** | F3/F5 | subagent + eventuale CLI esterna | doubt-driven **opt-in per alta stake** (non default) |
| **3 inietti always-on ogni turno**: using-superpowers + ponytail + explanatory (+ security-guidance hooks) | ogni risposta | latente ma cumulativo | ponytail → **lite default**; explanatory valutare se token-critico; using-superpowers non disabilitabile (loader) |
| **Registro ~60 descrizioni skill sempre caricate** | ogni sessione | some migliaia di token latenti | disabilitare feature-dev/code-simplifier (+ meta se non usati) |

---

## Sintesi per la migrazione
- **Disarmare i duplicati:** disabilita `feature-dev` (code-architect/explorer/reviewer duplicano architect+SDD+code-reviewer) e `code-simplifier` (duplica code-simplification).
- **Unificare i path artefatto** via CLAUDE.md (spec in `docs/specs/`, plan in `docs/plans/`, task in Backlog MD) — elimina la frammentazione `docs/superpowers/` vs `SPEC.md`/`tasks/` vs `.scratch/`.
- **Rendere deterministici i trigger** via regole di fase/scope in CLAUDE.md (§3).
- **Governare le 5 direttive contrapposte** (D1-D5) con regole scritte esplicite (§2).
