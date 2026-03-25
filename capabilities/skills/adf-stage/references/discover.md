# Discover Stage Reference

> "What are we trying to accomplish?"

## Phase Model

| Phase | Description | Exit Signal |
|-------|-------------|-------------|
| **Exploration** | Divergent brainstorming — gathering ideas, researching, following threads | Human says "I have enough to crystallize" |
| **Crystallization** | Synthesis into coherent draft brief and intent | Draft brief exists with all core sections. Ready for review |
| **Review Loop** | Structured feedback cycles (internal mandatory, external optional) | No Critical/High issues remaining |
| **Finalization** | Exit criteria check, handoff prep | All exit criteria met. Human confirms ready for Design |

## Key Deliverables

| Output | Location |
|--------|----------|
| `intent.md` | Project root (immutable once finalized) |
| `brief.md` | `docs/active/brief.md` |

## Brief Core Sections (all types)

1. Classification (type + modifiers)
2. Summary
3. Scope (in/out explicit)
4. Success Criteria (verifiable)
5. Constraints
6. Open Questions
7. Issue Log

**Type-specific extensions:**
- **App + commercial:** target market, competitive landscape, monetization, financial forecast, go-to-market
- **Workflow:** trigger, integration points, data flow, error handling
- **Artifact:** audience, format requirements, source materials

## Review Dimensions

1. Completeness — all required sections populated?
2. Clarity — would someone new understand this?
3. Measurability — success criteria verifiable?
4. Scope — boundaries explicit? in/out clear?
5. Consistency — internal contradictions?
6. Intent alignment — brief outcomes match intent goals?
7. Constraint adherence — respects stated constraints?
8. Downstream usability — would Design know what to do?
9. Assumption risk — unstated assumptions? risky dependencies?
10. Feasibility — red flags? unrealistic expectations?

## Discover-Specific Exit Criteria

- [ ] `intent.md` exists and passes validation (understandable by new agent, specific, stable, concise, no implementation details)
- [ ] `brief.md` exists with all required sections (core + type-specific)
- [ ] Project classification assigned (type + modifiers)
- [ ] Scope boundaries clear (in/out explicit)
- [ ] Success criteria are verifiable (not vague)
- [ ] Open Questions empty or deferred to Design with rationale
- [ ] Constraints documented
