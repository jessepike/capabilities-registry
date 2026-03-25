---
name: operate-synthesis
description: This skill runs the Operate & Learn cycle — activates observation tracking, synthesizes accumulated signals into a report, assesses intent alignment, feeds actionable items to BACKLOG.md, and recommends a cycle decision (continue, fix, new Discover, or retire). It should be used when the user says "run operate", "synthesize observations", "how is it performing", "operational review", "cycle check", or when a living system needs its periodic health assessment.
---

# Operate Synthesis

Observe, synthesize, decide. Periodic health assessment for living systems — turns raw usage signals into structured insights and a recommended next action.

## Modes

### Full Synthesis
```
run operate synthesis
```
Activates observation tracking (if not active), synthesizes all observations, produces report, recommends cycle decision. Pauses for human decision at the end.

### Full Auto
```
run operate synthesis --full-auto
```
Runs synthesis and produces recommendations without pausing. Still requires human decision on cycle outcome (continue, fix, new Discover, retire) — but presents it as a recommendation, not a gate.

### Observation Only
```
run operate observation
```
Just logs current signals without synthesizing. For quick capture during a session.

## The Pipeline

### Phase 1: Activation Check

First run only — verify the system qualifies for Operate:

1. **Living System Gate** — does it have 2+ of:
   - Runs continuously or repeatedly
   - Accepts live input
   - Maintains evolving state
   - Expected to change based on observed usage

   If gate fails → seal status.md as Complete. Do not activate Operate.

2. **Intention alignment check** — re-read intent.md. Is the deployed system still serving the stated intent?

3. **Set observation targets** — what to watch for, based on system type:

   | System Type | Primary Signals |
   |-------------|----------------|
   | Web app | User flow friction, error rates, feature usage, load performance |
   | API/service | Latency, error rates, usage patterns, auth failures |
   | Workflow/pipeline | Success rate, failure points, throughput, data quality |
   | MCP server | Tool usage frequency, error rates, response times |
   | Agent/plugin | Trigger accuracy, output quality, context consumption |

4. **Set synthesis cadence:**
   - Actively used app / MVP → weekly
   - Low-traffic tool or workflow → monthly
   - Background service → after 10+ observations accumulate

### Phase 2: Observation (ongoing)

Capture signals as they arise. Each observation:

| Date | Signal | Type | Severity | Context |
|------|--------|------|----------|---------|

**Signal types:**
- **Friction** — workarounds needed, unexpected behavior, confusing output
- **Error** — tool failures, exceptions, data issues
- **Gap** — missing capability, uncovered use case
- **Drift** — behavior diverging from intent over time
- **Delight** — something working better than expected
- **Pattern** — recurring behavior worth noting

**Severity:** High (unusable/data loss/intent blocked), Medium (recurring friction with workaround), Low (one-off/cosmetic)

Write to `docs/active/observations.md`. Append, don't overwrite — this is a running log.

### Phase 3: Synthesis

When cadence is reached or manually triggered:

1. **Read all observations** from `docs/active/observations.md`

2. **Cluster by theme** — group related observations into named clusters:
   - "Authentication friction" (3 observations)
   - "Data import gaps" (2 observations)
   - "Performance degradation under load" (1 observation)

3. **Assess intent alignment:**
   - Re-read intent.md
   - Score: Strong / Adequate / Degrading / Broken
   - Evidence: what observations support this assessment

4. **Classify each cluster:**
   - Systematic gap — fundamental missing capability
   - Incremental improvement — small enhancement to existing feature
   - Usage evolution — users using it differently than designed
   - Noise — one-off, not actionable

5. **Feed BACKLOG.md** — for each actionable cluster, create a backlog item:
   - Type: Bug / Enhancement / Architecture
   - Priority: based on severity and frequency
   - Why: link to specific observations

6. **Cross-project pattern check** — before writing the report, search KB for similar signals from other projects:

   Use `mcp__knowledge-base__search_knowledge` with queries derived from each cluster:
   ```
   For each cluster:
     search_knowledge(query: "{cluster theme} {system type}", content_type: "learning", limit: 5)
   ```

   If relevant results found:
   - Note them in the synthesis report under "Cross-Project Patterns"
   - Flag if another project solved a similar problem (avoid reinventing)
   - Flag if the same pattern is recurring across projects (systemic issue)

   If no relevant results → skip the section. Don't force it.

7. **External perspective** (optional but recommended):
   ```bash
   codex exec --sandbox read-only --json -C "$(pwd)" - <<'PROMPT'
   Review these system observations and the original intent:

   Intent: {intent.md content}
   Observations: {observations.md content}

   Assess: Is this system still serving its stated intent?
   What patterns do you see? What's the biggest risk?
   PROMPT
   ```

8. **Write synthesis report** to `docs/active/synthesis-{date}.md`:

```markdown
## Synthesis Report — {date}

### Intent Alignment: {Strong / Adequate / Degrading / Broken}
{evidence}

### Signal Summary
- Total observations: {count}
- By type: {Friction: N, Error: N, Gap: N, Drift: N, Delight: N, Pattern: N}
- By severity: {High: N, Medium: N, Low: N}

### Clusters

#### {Cluster 1 name} — {classification}
- Observations: {count}
- Severity: {highest in cluster}
- Summary: {what's happening}
- Action: {backlog item created / monitor / no action}

#### {Cluster 2 name} — {classification}
...

### Cross-Project Patterns
{Only include if KB search returned relevant results}
- {Pattern from project X}: {how it relates to current observations}
- {Pattern from project Y}: {solved via Z — consider similar approach}

### BACKLOG Items Created
- {B-ID}: {item} — from cluster {name}

### Cycle Recommendation
{Continue observing / Fix in place / Launch new Discover / Retire}
Rationale: {why}
```

9. **Save learnings to KB** — after writing the report, persist key insights for cross-project value:

   For each cluster classified as **Systematic gap** or **Usage evolution**, save a learning:
   ```
   mcp__knowledge-base__send_to_kb(
     content: "{cluster summary}. Observed in {project name} during Operate cycle. Intent alignment: {rating}. {what was learned}",
     content_type: "learning",
     title: "{cluster theme} — {project name} operate cycle",
     topics: ["{system type}", "operate", "{cluster theme}"],
     source_project: "{project name}"
   )
   ```

   **What to save:**
   - Patterns that would help a future project avoid the same friction
   - Usage evolution insights (how real usage diverged from design assumptions)
   - Systemic gaps that might affect similar system types

   **What NOT to save:**
   - Project-specific bugs (those go to BACKLOG, not KB)
   - Noise clusters
   - Incremental improvements (too granular for cross-project value)

### Phase 4: Cycle Decision

Present the recommendation to the human:

**Decision matrix:**

| Condition | Recommendation |
|-----------|---------------|
| Alignment Strong/Adequate, no High clusters | **Continue observing** |
| Isolated improvements, no intent revision needed | **Fix in place** — lightweight Develop sprint |
| Alignment degrading, usage evolved, major new need | **New Discover** — synthesis seeds updated brief |
| System obsolete, superseded, not in use | **Retire** — archive and seal |

**Decision heuristic:**
```
Alignment Broken             → New Discover or Retire
3+ High severity clusters    → New Discover or Fix in place
Intent fundamentally shifted → New Discover
Improvements incremental     → Fix in place
No active use                → Retire
Otherwise                    → Continue observing
```

**Checkpoint (always, even in --full-auto):** "Cycle recommendation: {X}. Approve, or choose a different path?"

The human decides. This is the one gate that never gets auto-skipped — it's a strategic direction decision.

### Phase 5: Execute Decision

Based on human's choice:

**Continue observing:**
- Clear processed observations from the log (archive to `docs/archive/`)
- Reset observation counter
- Note in status.md: "Operate: continuing observation, next synthesis {date}"

**Fix in place:**
- Create backlog items for the fixes (if not already done in synthesis)
- Run a lightweight develop-sprint on just the fix items
- Re-enter observation after fixes ship

**New Discover:**
- Create evidence-seeded brief from synthesis:
  - Problem statement → dominant friction/gap patterns from observations
  - Success criteria → what actually mattered in real use
  - Scope → bounded by what usage revealed
  - Label: `Evidence-seeded from: docs/active/synthesis-{date}.md`
- Archive current brief to `docs/archive/`
- Transition to Discover with the seeded brief
- Run `discover-sprint — brief already exists`

**Retire:**
- Archive all active docs
- Seal status.md as "Retired — {rationale}"
- Final commit: `chore(operate): system retired — {reason}`

## KB Integration

KB integration is built into the synthesis pipeline — steps 6 (cross-project search) and 9 (save learnings). The compounding effect: each Operate cycle makes the KB smarter. Similar systems in the future start with prior evidence, not assumptions.

**Requires:** Knowledge Base MCP server running (`mcp__knowledge-base__*` tools available). If KB is unavailable, skip steps 6 and 9 — log a note in the report that KB integration was skipped.

## Important Notes

- **Operate is a loop, not a sprint** — it doesn't "complete." It cycles until a decision terminates it.
- **Observations are low-ceremony** — just capture the signal. Don't over-structure during observation. Structure happens in synthesis.
- **Synthesis is where the value is** — raw observations are noise. Clustered, assessed, and actionable observations are intelligence.
- **The cycle decision is always human-gated** — even in full-auto. This is a strategic choice about the system's future.
- **Evidence-seeded Discover is powerful** — a second cycle that starts from real usage data produces dramatically better results than the first cycle's assumptions.
- **Save to KB** — Operate learnings are the most valuable knowledge to preserve. They're grounded in reality, not speculation.
