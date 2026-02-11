---
type: "review-request"
project: "Capabilities Registry Cross-Agent Alignment"
version: "0.1"
created: "2026-02-11"
updated: "2026-02-11"
---

# Review Request: Cross-Agent Capabilities Registry Plan

Please review the plan at:

- `docs/cross-agent-registry-plan.md`

Objective:

- Verify this plan is sufficient to align the capabilities registry across Claude Code, Codex, and Gemini.
- Verify the plan is extensible for additional clients in the future.
- Verify MCP always-on and scope policy (project vs user/global) is explicit, safe, and enforceable.

## Required Review Outputs

1. Findings prioritized by severity (`Critical`, `High`, `Medium`, `Low`).
2. Gaps in execution sequencing, ownership, or acceptance criteria.
3. Missing risks or governance concerns, especially around always-on MCP servers.
4. Specific schema recommendations for client compatibility and scope metadata.
5. Recommendation: `Approve`, `Approve with changes`, or `Do not approve`.

## Focus Areas

1. Schema design for multi-client compatibility.
2. Validation gate completeness.
3. Install/launcher metadata completeness requirements.
4. Policy quality for always-on MCP designation.
5. Scope decision logic (`project` vs `user/global`) and least-privilege defaults.
6. Whether this plan can absorb future clients without redesign.

## Review Checklist

1. Is each phase independently verifiable with clear acceptance criteria?
2. Are MCP scope rules deterministic and audit-friendly?
3. Does the plan prevent promoting incomplete or non-installable MCP entries?
4. Are bundled MCP and standalone MCP semantics unambiguous?
5. Are agent artifacts and manifest references sufficiently governed?
6. Are review and release gates strong enough to avoid regression?

## Suggested Response Format

1. Executive summary (3-6 bullets).
2. Findings list (severity-ordered).
3. Recommended plan edits (actionable deltas).
4. Final disposition (`Approve` / `Approve with changes` / `Do not approve`).
