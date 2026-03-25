---
name: deliver-sprint
description: This skill runs the entire Deliver stage autonomously — re-validates Develop output, runs security audit, plans deployment, delegates infra setup to Codex, deploys, runs browser QA and production validation, documents access, and closes out. It should be used when the user says "run deliver", "deliver sprint", "ship this", "deploy", "go to production", or wants the Deliver stage to run with minimal manual orchestration.
---

# Deliver Sprint

Ship it. Re-validate → security audit → plan deployment → set up infra → deploy → browser QA → validate in production → document access → close out. One command.

## Modes

### With Checkpoints
```
run deliver sprint
```
Pauses at: re-validation results, security audit findings, post-deploy QA results, and before closeout.

### Full Auto
```
run deliver sprint --full-auto
```
Runs without stopping. Only pauses for Critical security findings or deployment failures that need human intervention.

### Resume
```
resume deliver sprint
resume deliver sprint --full-auto
```

## The Pipeline

### Phase 1: Re-Validate Develop Output

Before touching deployment, verify what came out of Develop is solid. Run the checks that Develop's exit should have caught — trust but verify.

1. **Full test suite** — run all automated tests. Must be 95%+ pass rate. If not, stop — Develop isn't done.
2. **Design drift check** — `project-health --scope design-drift`. Verify build matches design.
3. **Doc freshness** — `project-health --scope freshness`. Docs current?
4. **Code hygiene** — `project-health --scope hygiene,secrets`. No debug prints, no hardcoded secrets, no placeholder implementations.
5. **Dependency audit** — `project-health --scope deps`. Known CVEs? Outdated packages?

If any Critical issues found → stop. Develop output is not ready for Deliver.

**Checkpoint (skip in --full-auto):** Report re-validation results. "Develop output is clean" or "Found {issues} — fix before proceeding?"

### Phase 2: Security Audit

Pre-deploy security review. Borrowed from G-Stack's `/cso` pattern.

1. **OWASP Top 10 scan** — check for common web vulnerabilities:
   - Injection (SQL, command, XSS)
   - Broken authentication/authorization
   - Sensitive data exposure
   - Security misconfiguration
   - Known vulnerable components (from dep audit)

2. **Secrets scan** — comprehensive check beyond project-health:
   - .env files not gitignored
   - API keys in code or config
   - Credentials in git history (last 10 commits)
   - Hard-coded connection strings

3. **Access control review** — if applicable:
   - Are admin routes protected?
   - Are API endpoints authenticated?
   - Are CORS settings restrictive?

4. **External security review** — delegate to Codex for independent perspective:
   ```bash
   codex exec --sandbox read-only --json -C "$(pwd)" - <<'PROMPT'
   Security audit of this codebase. Check for:
   - OWASP Top 10 vulnerabilities
   - Hardcoded secrets or credentials
   - Missing authentication/authorization
   - SQL injection, XSS, CSRF risks
   - Insecure dependencies
   Report each finding with severity and file:line location.
   PROMPT
   ```

**Checkpoint (skip in --full-auto unless Critical):** Report security findings. Critical findings always pause — even in full-auto.

### Phase 3: Deployment Planning

1. **Read AGENTS.md** — check Deployment section for target platform
2. **Determine scope:**
   - App MVP → first-time infrastructure + deployment
   - App feature → deploy to existing production
   - Workflow → installation/activation in target
   - Artifact → export/distribution
3. **Create deployment plan** in `docs/active/deploy-plan.md`:
   - Target environment
   - Infrastructure needed
   - Environment variables / secrets to configure
   - Deployment steps
   - Rollback plan
   - Post-deploy validation steps
4. **Check deployment tooling** — is the Vercel plugin (or equivalent) available?

### Phase 4: Infrastructure Setup (via Codex)

Delegate infrastructure work to Codex:

```bash
codex exec --full-auto --json -C "$(pwd)" - <<'PROMPT'
Set up deployment infrastructure per docs/active/deploy-plan.md.
{specific infra tasks: CI/CD, hosting config, env vars, database setup}
Run any setup scripts. Verify the environment is ready for deployment.
PROMPT
```

For OrbStack-dependent infra (databases, build tools): flag that these need to run in the dev VM.

Commit: `chore(deliver): infrastructure setup — {summary}`

### Phase 5: Deploy

Execute the deployment per the plan:

1. **Build** — run the production build (in OrbStack if needed)
2. **Deploy** — push to target (Vercel, Railway, etc.)
3. **Verify deployment** — check that the deployment completed without errors
4. **Smoke test** — basic health check (is the URL responding? Does the index page load?)

Commit: `chore(deliver): deployed to {target}`

### Phase 6: Browser QA

Interactive testing via Claude in Chrome (if the project has a web interface):

1. **Load the production URL** in browser
2. **Test key user flows** — the 3-5 most important workflows
3. **Screenshot each flow** — capture visual state for the record
4. **Check responsive layout** — mobile + desktop viewports
5. **Verify error states** — what happens with bad input, missing auth, empty data?

For non-web projects (CLI tools, workflows, APIs): skip browser QA, run appropriate integration tests instead.

### Phase 7: Three-Tier Production Validation

1. **Tier 1: Automated** — run test suite against production/staging. 95%+ pass rate.
2. **Tier 2: Browser/Agent** — key user flows verified (Phase 6 results). No critical bugs.
3. **Tier 3: Manual** — human acceptance testing. Present specific scenarios to test.

**Checkpoint (skip in --full-auto):** "All three tiers complete. Results: {summary}. Approve for closeout?"

Tiers are progressive — issues in later tiers trigger fixes and re-testing from Tier 1.

### Phase 8: Access Documentation

Create access docs — the human needs to be able to use this without assistance:

1. **URLs** — production URL, staging URL if applicable
2. **Credentials** — admin accounts, API keys (reference .env, don't write secrets)
3. **Usage instructions** — how to use the thing
4. **Monitoring** — where to check if something goes wrong
5. **Rollback** — how to revert if needed

Write to README.md or `docs/active/access.md`.

### Phase 9: Closeout

1. **Cleanup** — .gitignore current, no transients, no debug code, no unused deps
2. **Success criteria gate** — map each criterion from brief.md to evidence:
   - Criterion 1: ✅ Complete / ⏸️ Deferred / ❌ Not met
   - Criterion 2: ✅ / ⏸️ / ❌
3. **Artifact lifecycle** — keep: intent, brief, design. Archive: plan, manifest, deploy-plan, test results
4. **Commit verification** — no uncommitted changes
5. **Status.md seal** — mark stage complete, structured handoff

### Phase 10: Living System Gate

Determine next stage:
- Does this system run continuously, accept live input, maintain state, expect to change based on usage?
- If 2+ of those are true → transition to Operate
- If not → seal as Complete

**If transitioning to Operate — seed initial observations:**

Deliver has already surfaced real findings. Don't lose them. Create `docs/active/observations.md` and seed it with observations extracted from earlier phases:

1. **From Re-validation (Phase 1):**
   - Any non-critical issues that passed but are worth watching (e.g., test coverage gaps, minor design drift)
   - Dependency warnings (outdated but not CVE-level)

2. **From Security Audit (Phase 2):**
   - Low/Med findings that weren't blocking but should be monitored
   - Areas flagged for hardening in future iterations

3. **From Browser QA (Phase 6):**
   - UX friction noticed during flow testing
   - Responsive layout quirks
   - Edge cases that worked but felt brittle

4. **From Production Validation (Phase 7):**
   - Performance baselines worth tracking (load times, response times)
   - Tier 3 manual test notes from the human

Format each as a standard observation row:
```markdown
| {date} | {finding from deliver phase} | {type} | {severity} | Seeded from Deliver — {phase name} |
```

This gives Operate a running start instead of a blank log. Only seed findings that are **worth watching** — don't dump every passing check into the log.

Commit: `chore(deliver): stage complete — {summary}`

### Final Report

```
## Deliver Sprint Complete

Re-validation: {PASS / issues found}
Security audit: {PASS / findings count by severity}
Deployment: {target}, {URL}
Browser QA: {flows tested}, {screenshots captured}
Tier 1 (automated): {pass rate}
Tier 2 (browser): {PASS / issues}
Tier 3 (manual): {PASS / pending human testing}

Success criteria:
- {criterion}: ✅ / ⏸️ / ❌

Living System Gate: {Operate / Complete}
Ready for: {Operate / Archive}
```

## Important Notes

- **Re-validation is not optional** — even if Develop looked clean. Catches regression, missed tests, drift.
- **Security audit always blocks on Critical** — even in full-auto. Never ship known Critical security issues.
- **Browser QA requires Claude in Chrome** — if not available, skip and note in report.
- **Rollback plan before deploy** — always know how to undo before you do.
- **Access docs are the exit test** — can a human use this without the agent explaining it? If not, Deliver isn't done.
- **Atomic commits** — infrastructure, deployment, and closeout each get their own commit.
