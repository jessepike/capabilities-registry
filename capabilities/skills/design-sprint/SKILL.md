---
name: design-sprint
description: This skill runs the entire Design stage autonomously — research, write design docs, create diagrams, challenge assumptions, run multi-model reviews, and iterate until the design passes the HARD GATE. One command per backlog item or for the full design. It should be used when the user says "run design", "design sprint", "design this", "work through the design", "start designing", or wants the Design stage to run with minimal human intervention. Also use when the user has multiple design backlog items and wants them worked through systematically.
---

# Design Sprint

Run the Design stage as an autonomous pipeline. Research → Write → Diagram → Challenge → Review → Iterate. One command, the agent works through it, human approves at gates.

## Why This Exists

The Design stage has 5-7 steps per backlog item. With 9 items, that's 45-63 manual steps. This skill chains them into an autonomous flow where the agent works through each item, pauses only when human judgment is needed.

## Two Modes

### Mode 1: Single Item Sprint

```
design sprint on B-005 (tech stack)
```

Runs the full design pipeline for one backlog item.

### Mode 2: Full Design Sprint (with checkpoints)

```
run design sprint
```

Works through ALL design backlog items in sequence. Pauses between items for human checkpoint.

### Mode 3: Full Auto (no stops)

```
run design sprint --full-auto
```

Runs through all items without pausing between them. Still runs research, reviews, and HARD GATE — but no human checkpoints until the end. Only stops for Critical + High-complexity issues needing a decision.

## The Pipeline (per backlog item)

### Phase 1: Research

Before writing anything, investigate the design space:

1. Read the backlog item for requirements and context
2. Read the brief for constraints and success criteria
3. Spawn **research-swarm** agents in parallel for the relevant angles:
   - Technical: architecture patterns, frameworks, libraries
   - Best practices: industry standards for this type of system
   - Community: recent practitioner experience, gotchas
   - Codebase: existing patterns if building on prior work

4. Consolidate research findings
5. If KB MCP is available, save key findings for future reference

### Phase 2: Write Design Doc

Based on research findings + brief requirements:

1. Create or update the design doc section in `docs/active/design.md`
2. Include: approach, rationale, alternatives considered, trade-offs, acceptance criteria
3. Log design decisions in `decisions.md`
4. If the item warrants a separate doc (>100 lines of design content), create `docs/active/design-{component}.md`

Follow the required sections for the project type:
- **All types:** Summary, Capabilities, Interface, Decision Log, Open Questions
- **App:** Architecture, Tech Stack, Data Model, Security
- **Workflow:** Orchestration, Integration Points, Data Flow, Error Handling
- **Artifact:** Format Spec, Content Outline, Source Materials

### Phase 3: Diagram (if applicable)

If the design item involves architecture, data flow, component structure, or system interactions:

1. Create a structural diagram via **Excalidraw** (flowchart, architecture, data model)
2. Save to the project directory
3. Reference the diagram in the design doc

Not every item needs a diagram. Skip for items that are purely decisions (tech stack choice) or policies (error handling strategy).

### Phase 4: Internal Review

Run the internal review cycle on the design doc section:

1. Evaluate against Design review dimensions: brief alignment, completeness, feasibility, consistency, capability coverage, interface clarity, decision quality, downstream usability
2. Apply severity/complexity matrix — auto-fix what can be fixed
3. Minimum 2 cycles, stop when clean
4. Log issues in the Issue Log

### Phase 5: External Review

After internal review passes:

1. **Codex review** — `codex exec --sandbox read-only` with the design doc. Focus: implementation feasibility, technical blind spots, alternative approaches.
2. **Claude fresh review** — `claude -p` with fresh context. Focus: architectural coherence, spec compliance with brief, consistency across design items.
3. Incorporate feedback — fix Critical/High issues
4. Verification pass — confirm fixes hold

### Phase 6: Checkpoint

After the item passes review, pause for human:

```
✅ B-005 (Tech Stack) design complete.

Summary: {one-line summary of the design decision}
Diagram: {path if created}
Issues resolved: {count}
External findings: {count unique}

Proceed to next item (B-006)? Or review the design doc first?
```

**Human can:**
- Approve and continue to next item
- Review the design doc and request changes
- Skip to a different backlog item
- Stop the sprint (resume later)

### Phase 7: Update Project State

After human approves:
1. Update BACKLOG.md — mark item as designed
2. Update status.md — current progress
3. Commit: `docs(design): {item} — {summary}`

Then proceed to next backlog item (back to Phase 1).

## After All Items Complete

When the last backlog item passes review:

### HARD GATE Validation

Automatically validate the full design against the HARD GATE:

**Problem Validation:**
- [ ] Problem statement is specific
- [ ] Problem validated through evidence
- [ ] Current state measured and understood
- [ ] Solution doesn't duplicate existing capability

**Design Quality:**
- [ ] All requirements have measurable acceptance criteria
- [ ] All assumptions validated or have validation plans
- [ ] Success criteria measurable before implementation
- [ ] "How do we know this works?" has a concrete answer

**Risk Assessment:**
- [ ] Technical feasibility confirmed
- [ ] Resource estimate provided
- [ ] "What if we don't build this?" answered
- [ ] Alternative approaches considered and documented

**Decision Forcing:**
- [ ] No success criteria marked "partial" or "deferred"
- [ ] No assumptions marked "to be validated during implementation"
- [ ] No critical dependencies on unproven technology

### Develop Handoff

If HARD GATE passes, generate the Develop Handoff section:
1. Design Summary
2. Key Design Decisions (table)
3. Capabilities Needed
4. Open Questions for Develop
5. Success Criteria (from brief)
6. What Was Validated (review outcomes)
7. Implementation Guidance (build order, edge cases)
8. Reference Documents (read order)

### Final Report

```
## Design Sprint Complete

Items designed: {count}
Total research agents spawned: {count}
Total review cycles: {count}
External reviews: {count}
Diagrams created: {count}
Decisions logged: {count}

HARD GATE: {PASS / FAIL with specific failures}

Ready for Develop: {Yes / No — blocked by {specific items}}
```

## Resuming a Partial Sprint

If the sprint was stopped mid-way:

```
resume design sprint
```

Reads BACKLOG.md to identify which items are designed vs pending. Picks up from the next undesigned item.

## Important Notes

- **Human checkpoints between items** — the sprint pauses for approval after each item. Not fully unattended across items (but fully autonomous within each item).
- **Research is not optional** — every design decision should be grounded in research, not assumptions. The research phase runs even if it feels obvious.
- **Diagrams are judgment calls** — the agent decides if a diagram helps based on the item type. Override with "include a diagram for this one" or "skip the diagram."
- **HARD GATE is mandatory** — no shortcuts. If it fails, the sprint reports what needs fixing.
- **Each item gets committed** — atomic commits after each approved design item. Not one big commit at the end.
