# Design Stage Reference

> "How will we approach it?"

## Phase Model

| Phase | Description | Exit Signal |
|-------|-------------|-------------|
| **Intake & Clarification** | Understand brief, resolve ambiguities, surface decisions | Agent has clarity to draft design.md. Human confirms |
| **Technical Design** | Produce design artifacts based on decisions | Draft design.md exists with all required sections |
| **Review Loop** | Validate decisions through internal/external review | No Critical/High issues remaining |
| **Finalization** | Exit criteria check, handoff prep | All exit criteria met. Human confirms ready for Develop |

## Key Deliverables

| Output | Location |
|--------|----------|
| `design.md` | `docs/active/design.md` |
| Supporting specs (if >500 lines) | `docs/active/design-*.md` |
| Updated decision log | `decisions.md` |

**Breakout threshold:** 500 lines. Under 500: keep everything in design.md. Over 500: create parent (~100-200 lines) with links to child documents.

## Required Sections by Type

**All types:** Summary, Capabilities, Interface & Format, Decision Log, Backlog, Open Questions, Issue Log, Develop Handoff, Review Log, Revision History

**App (additional):** Architecture, Tech Stack, Data Model, Security

**Workflow (additional):** Orchestration, Integration Points, Data Flow, Error Handling, Triggers

**Artifact (additional):** Format Specification, Content Outline, Source Materials

## Develop Handoff Section (required)

1. **Design Summary** — 2-3 sentence overview
2. **Key Design Decisions** — table: Decision | Rationale | Implication for Develop
3. **Capabilities Needed** — runtime, libraries, tools, integrations
4. **Open Questions for Develop** — numbered, with context
5. **Success Criteria** — checkboxes from brief
6. **What Was Validated** — review outcomes summary
7. **Implementation Guidance** — build order, edge cases, integration test strategy
8. **Reference Documents** — read order (intent, brief, design)

## Review Dimensions

1. Brief alignment — does design deliver what brief specifies?
2. Completeness — all required sections for project type?
3. Feasibility — can this be built with stated constraints?
4. Consistency — internal contradictions?
5. Capability coverage — tools/skills sufficient?
6. Interface clarity — would a developer know what to build?
7. Data model soundness — structures support requirements?
8. Decision quality — rationale documented? options considered?
9. Downstream usability — can Develop start from this?

## Design-Specific Exit Criteria

- [ ] `design.md` exists with all required sections (core + type-specific)
- [ ] Design aligns with brief — delivers what was specified
- [ ] Capabilities inventory complete (tools, skills, agents identified)
- [ ] Interface/format specified clearly for implementation
- [ ] Decision log captures key choices with rationale
- [ ] Open Questions empty or explicitly deferred to Develop
- [ ] Develop Handoff section complete

## HARD GATE (must pass before Develop)

**Problem Validation:**
- [ ] Problem statement is specific (not generic or assumed)
- [ ] Problem validated through evidence
- [ ] Current state measured and understood
- [ ] Solution doesn't duplicate existing capability

**Design Quality:**
- [ ] All requirements have measurable acceptance criteria
- [ ] All assumptions validated OR have validation plans
- [ ] Success criteria measurable BEFORE implementation
- [ ] "How do we know this works?" has a concrete answer

**Risk Assessment:**
- [ ] Technical feasibility confirmed (not theoretical)
- [ ] Resource estimate provided
- [ ] "What if we don't build this?" answered explicitly
- [ ] Alternative approaches considered and documented

**Decision Forcing:**
- [ ] No success criteria marked "partial" or "deferred to validation later"
- [ ] No assumptions marked "to be validated during implementation"
- [ ] No critical dependencies on unproven technology
