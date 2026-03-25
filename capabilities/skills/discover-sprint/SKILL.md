---
name: discover-sprint
description: This skill runs the Discover stage as a guided autonomous pipeline — research, draft or refine a brief, challenge assumptions, run multi-model reviews, and iterate until the brief passes exit criteria. Handles both greenfield projects (no brief yet) and existing briefs that need validation. It should be used when the user says "run discover", "discover sprint", "start discovery", "validate this concept", or wants the Discover stage to run with minimal manual orchestration.
---

# Discover Sprint

Run the Discover stage as a guided pipeline. The most human-judgment-heavy stage, so the sprint pauses more often for input — but it still eliminates the manual orchestration of research → write → challenge → review → iterate.

## Why Guided, Not Fully Autonomous

Discover is where the project's direction gets set. Bad assumptions here compound through every later stage. The sprint automates the mechanics (spawning research, running reviews, formatting docs) but pauses for human judgment on the substance (is this the right problem? right scope? right success criteria?).

## Modes

### Greenfield (no brief yet)
```
run discover sprint
```
Starts from scratch — research, draft intent, draft brief, challenge, review.

### Existing Brief
```
run discover sprint — brief already exists
```
Skips writing. Jumps to challenge → review → iterate on what's there.

### Full Auto
```
run discover sprint --full-auto
```
Runs the full pipeline with minimal pauses. **Exception: intent.md approval is always required** — even in full-auto mode, the sprint stops for human sign-off on intent because it's immutable once set. All other checkpoints are skipped.

## The Pipeline

### Phase 1: Orient

1. Read existing project context (AGENTS.md, intent.md, BACKLOG.md, status.md)
2. Check for existing brief at `docs/active/brief.md`
3. Check for any raw concept docs, notes, or prior research in `docs/inbox/` or project root
4. Determine entry point: greenfield or existing brief

**If raw concept docs exist** (product briefs, meeting notes, idea docs):
- Identify them and ask: "Found {files}. Use these as source material for the brief?"

### Phase 2: Research

Spawn **research-swarm** for the problem space:

1. **Market/Landscape** — who else is solving this? What exists?
2. **User/Need** — who has this problem? How are they solving it today?
3. **Regulatory/Compliance** — any legal or regulatory requirements? (if applicable)
4. **Technical feasibility** — is this buildable? What are the hard problems?
5. **Prior knowledge** — search KB for related research, learnings, prior projects

Consolidate findings. Save to KB for future reference.

**Human checkpoint:** "Here's what the research found. Does this change your thinking about the project direction?"

### Phase 3: Intent

Draft `intent.md` from the research + any existing concept docs:
- Problem/Opportunity (1-3 sentences)
- Desired Outcome (1-3 sentences)
- Why It Matters (1-3 sentences)

**Human checkpoint — mandatory:** "Here's the draft intent. This becomes immutable once approved. Review and confirm, or tell me what to change."

Do not proceed until human approves intent.md.

### Phase 4: Brief

**If greenfield:** Draft `docs/active/brief.md` with all required sections:
- Classification (type + modifiers)
- Summary
- Scope (in/out — explicit boundaries)
- Success Criteria (verifiable, measurable)
- Constraints
- Open Questions
- Issue Log

Add type-specific sections:
- **App:** target market, competitive landscape, tech considerations
- **Workflow:** triggers, integration points, data flow, error handling
- **Artifact:** audience, format requirements, source materials

Ground everything in the Phase 2 research — no unsourced claims, no assumed facts.

**If existing brief:** Skip to Phase 5.

**Human checkpoint:** "Draft brief is ready for review. Want to read it before I run challenges?"

### Phase 5: Challenge

Run **office-hours** on the brief:

Challenge dimensions:
- Problem validation — is this real? How do we know?
- Market — who else? Why will this approach win?
- User — who specifically? Can you name people who'd use it?
- Scope — too big? Too small? What's the real MVP?
- Feasibility — can this actually be built? With what resources?
- Risks — what kills this? Biggest unspoken risk?
- Assumptions — which are validated vs hope?

Output: strengths, critical challenges, assumptions table, questions to answer.

**Human checkpoint:** "Here are the challenges. Which ones do you want to address now vs defer to Design?"

Incorporate human's responses. Update the brief.

### Phase 6: Review

Run **review-loop** — full autonomous cycle:

1. Internal review (2-10 cycles, auto-fix what can be fixed)
2. External review via Codex + Claude -p (independent perspectives)
3. Incorporate feedback
4. Verification pass
5. Report: ready or not ready

Review dimensions for Discover:
- Completeness — all required sections populated?
- Clarity — would someone new understand this?
- Measurability — success criteria verifiable?
- Scope — boundaries explicit? In/out clear?
- Consistency — internal contradictions?
- Intent alignment — brief outcomes match intent goals?
- Constraint adherence — respects stated constraints?
- Downstream usability — would Design know what to do?
- Assumption risk — unstated assumptions? Risky dependencies?
- Feasibility — red flags? Unrealistic expectations?

### Phase 7: Iterate (if needed)

If review found issues:
1. Fix Critical/High issues
2. Re-run office-hours on the specific areas that changed
3. Re-run review-loop
4. Repeat until clean

Most briefs take 2-3 iterations. The first pass catches structural issues, the second catches substance issues, the third is usually clean.

### Phase 8: Exit Validation

Run **adf-stage** exit criteria check:

- [ ] intent.md exists and is valid
- [ ] brief.md has all required sections (core + type-specific)
- [ ] Classification assigned
- [ ] Scope boundaries clear
- [ ] Success criteria verifiable
- [ ] Open Questions empty or deferred to Design with rationale
- [ ] Constraints documented
- [ ] Documentation current
- [ ] No Critical/High issues open
- [ ] Human sign-off obtained

### Phase 9: Transition

If exit criteria pass:

1. Archive working artifacts (research notes, drafts) to `docs/archive/`
2. Write handoff block to status.md
3. Commit: `chore(discover): stage complete — {summary}`
4. Suggest clearing context for Design stage

### Final Report

```
## Discover Sprint Complete

Research agents spawned: {count}
Office hours challenges: {count critical}, {count important}
Review cycles: {count} (internal: {n}, external: {n})
Assumptions identified: {count} ({validated} validated, {unvalidated} unvalidated)
Iterations: {count}

Deliverables:
- intent.md: approved
- brief.md: {version}, {word count}

Exit criteria: {PASS / FAIL with specifics}
Ready for Design: {Yes / No}
```

## Important Notes

- **More human checkpoints than other sprints** — Discover sets the direction. Wrong direction = wrong everything. The sprint pauses at: research findings, intent approval, brief draft, challenge responses, and exit.
- **Intent approval is mandatory and blocking** — the sprint will not proceed past Phase 3 without explicit human approval.
- **Research is not skippable** — even for "obvious" projects. The research often reveals competitors, regulations, or prior art that changes the approach.
- **Existing briefs still get challenged and reviewed** — having a brief doesn't mean it's good. The sprint validates it just as rigorously.
- **Save research to KB** — Discover research is the most valuable to preserve. Future projects in the same domain will find it.
