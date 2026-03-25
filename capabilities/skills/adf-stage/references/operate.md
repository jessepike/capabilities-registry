# Operate & Learn Reference

> "Is this working well, and what should change?"

Not a sequential 5th stage — a **loop closure mechanism** activated after Deliver for living systems. Converts real-world evidence into starting point for the next cycle.

## Living System Gate (mandatory first check)

A living system has at least 2 of:
- Runs continuously or repeatedly
- Accepts live input
- Maintains evolving state
- Expected to change based on observed usage

**If the artifact fails this check:** seal status.md as Complete. Do not activate Operate & Learn. One-shot artifacts (reports, presentations) complete at Deliver.

## Phase Model

| Phase | Description | Cadence |
|-------|-------------|---------|
| **1. Activation** | One-time setup. Verify intent alignment. Define observation targets. Set synthesis cadence. | Once (at loop entry) |
| **2. Observation** | Log signals during real use. Low ceremony — just capture. | Every session |
| **3. Synthesis** | Cluster observations, assess alignment, feed backlog, write report. | Weekly / monthly / threshold |
| **4. Cycle Decision** | Human decision: continue, fix, new cycle, or retire. | After each Synthesis |

Phases 2-3 repeat until a Cycle Decision is reached.

## Signal Types (Phase 2)

| Type | Description |
|------|-------------|
| **Friction** | Workarounds needed, unexpected behavior |
| **Error** | Tool failures, exceptions, data issues |
| **Gap** | Missing capability, uncovered use case |
| **Drift** | Behavior diverging from intent over time |
| **Delight** | Something working better than expected |
| **Pattern** | Recurring behavior worth noting |

**Severity:** High (unusable/data loss/intent blocked), Med (recurring friction with workaround), Low (one-off/cosmetic)

**Observation log format:**

| Date | Signal | Type | Severity | Context |
|------|--------|------|----------|---------|

Location: `docs/active/observations.md`

## Synthesis Process (Phase 3)

1. **Cluster** observations by theme
2. **Assess intent alignment:** Strong / Adequate / Degrading / Broken
3. **Classify** each cluster: Systematic gap / Incremental improvement / Usage evolution / Noise
4. **Feed** actionable clusters to BACKLOG.md
5. **Write** synthesis report to `docs/active/synthesis-YYYY-MM-DD.md`

## Cycle Decision Matrix (Phase 4)

| Decision | When | Action |
|----------|------|--------|
| **Continue observing** | Alignment Strong/Adequate, no High clusters | Return to Observation |
| **Fix in place** | Isolated improvements, no intent revision needed | Lightweight Develop sprint, then back to Observation |
| **New Discover** | Alignment degrading, usage evolved, major new need | Synthesis seeds new brief; full cycle restarts |
| **Retire** | System obsolete, superseded, not in use | Archive; status.md sealed |

### Decision Heuristic

```
Alignment Broken             → New Discover or Retire
3+ High severity clusters    → New Discover or Fix in place
Intent fundamentally shifted → New Discover
Improvements incremental     → Fix in place
No active use                → Retire
Otherwise                    → Continue observing
```

### Tie-breakers

**New Discover vs Fix:** Fix if clusters are isolated, alignment Adequate+, single sprint scope. New Discover if clusters span architecture, alignment Degrading, or usage diverged from design.

**New Discover vs Retire:** Retire if no active usage for full synthesis period, superseded, or maintenance cost exceeds benefit.

## Seeding a New Discover Brief

Copy brief.md and replace with evidence-grounded content:
- Problem statement → dominant friction/gap patterns
- Success criteria → what actually mattered in use
- Scope → bounded by what usage revealed
- Context → intent alignment rating + key observations

Label: `Evidence-seeded from: docs/active/synthesis-YYYY-MM-DD.md`

## Synthesis Cadence Defaults

| System Type | Default |
|-------------|---------|
| Actively used app / MVP | Weekly |
| Low-traffic tool or workflow | Monthly |
| Background MCP server | After 10+ observations |
