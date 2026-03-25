---
name: office-hours
description: This skill runs a structured product challenge session — like a VC or advisor grilling your concept, brief, or design. It pressure-tests assumptions, finds blind spots, and strengthens the work before you commit to building. It should be used when the user wants to stress-test an idea, challenge assumptions, play devil's advocate, poke holes in a plan, or get a tough-love review. Trigger on phrases like "office hours", "challenge this", "poke holes", "stress test", "play devil's advocate", "what am I missing", "is this solid", "tear this apart", or when the user has a brief or design and wants it pressure-tested before moving forward.
---

# Office Hours

A structured product challenge session. Think YC office hours — direct, challenging questions that find blind spots and strengthen your thinking before you commit resources.

## Why This Exists

Reviews find problems in what's written. Office hours find problems in what's NOT written — the assumptions you didn't question, the scenarios you didn't consider, the questions you can't answer yet. It's the difference between "is this document well-structured?" and "should you build this at all?"

## How It Works

### Step 1: Read the Material

Read the artifact being challenged (brief, design, intent, plan — whatever the user points to). Also read:
- `intent.md` — the North Star
- `AGENTS.md` — project context
- Any prior research or decisions

### Step 2: Identify Challenge Dimensions

Based on the artifact type, select relevant challenge dimensions:

**For a Product Brief (Discover stage):**

| Dimension | Core Question |
|-----------|--------------|
| **Problem Validation** | Is this a real problem? How do you know? Who told you? |
| **Market** | Who else is solving this? Why will your approach win? What's the unfair advantage? |
| **User** | Who specifically uses this? Can you name 5 people who would pay/use it? |
| **Scope** | Is this too big? Too small? What's the real MVP — not your MVP, the actual minimum? |
| **Feasibility** | Can you actually build this? With what resources? In what timeline? |
| **Business Model** | How does this make money or deliver value? Who pays? |
| **Risks** | What kills this? What's the single biggest risk you're not talking about? |
| **Assumptions** | List every assumption. Which ones are validated? Which are hope? |
| **Differentiation** | If I Google this problem, what shows up? Why is your thing different? |
| **First User** | Who's the first person to use this, and what's their first 5 minutes like? |

**For a Technical Design (Design stage):**

| Dimension | Core Question |
|-----------|--------------|
| **Complexity** | Is this overengineered? What's the simplest version that works? |
| **Dependencies** | What are you depending on that you don't control? |
| **Scalability** | What breaks first when load increases? |
| **Data** | Where does the data come from? How do you know it's clean? |
| **Integration** | What talks to what? What happens when a connection fails? |
| **Security** | What's the worst thing that happens if someone malicious gets access? |
| **Maintenance** | Who maintains this in 6 months? What does that cost? |

### Step 3: Run the Challenge

For each relevant dimension, ask 2-3 pointed questions. These are not gentle suggestions — they're direct challenges that demand concrete answers.

**Rules for good challenges:**
- Ask questions the user can't answer with "yes" or "no"
- Challenge the STRONGEST parts too, not just the weak ones
- Look for circular reasoning ("we need X because of Y" — but Y depends on X)
- Find the unspoken assumptions
- Ask "what happens if this assumption is wrong?"
- Ask "who have you talked to about this?"

**Rules for discipline:**
- Do NOT propose solutions. Only ask questions.
- Do NOT expand scope. If something is explicitly out of scope, don't challenge the boundary — challenge whether the scope is the RIGHT boundary.
- Grade each challenge by impact: "If this isn't addressed, what's the consequence?"

### Step 4: Synthesize

After running through all dimensions:

```markdown
## Office Hours Summary: {artifact name}

**Date:** {today}
**Artifact:** {path}
**Stage:** {current stage}

### Strengths
What's solid — the parts that held up under pressure:
- {strength 1}
- {strength 2}

### Critical Challenges (must address before proceeding)
Issues where the consequence of not addressing is project failure or major pivot:

1. **{Challenge title}**
   - Question: {the hard question}
   - Why it matters: {consequence if not addressed}
   - What would resolve it: {type of answer needed, not the answer itself}

### Important Challenges (should address)
Issues that won't kill the project but will cause significant friction:

1. **{Challenge title}**
   - Question: {question}
   - Why it matters: {consequence}

### Assumptions Identified
Every assumption found, with validation status:

| # | Assumption | Validated? | Risk if Wrong |
|---|-----------|-----------|---------------|
| 1 | {assumption} | Yes / No / Partially | {what breaks} |

### Questions You Should Be Able to Answer
Before moving to the next stage, you should have concrete answers to:
1. {question}
2. {question}
3. {question}

### Verdict
{Ready to proceed / Needs work in these specific areas / Fundamental rethink needed}
```

## Multi-Model Office Hours

For maximum rigor, run the challenge from multiple perspectives:

1. **Claude (this session)** — architectural and strategic perspective
2. **Codex (via codex exec)** — implementation and technical feasibility perspective
3. **Claude -p (fresh context)** — completely independent perspective

Each model will catch different blind spots. Synthesize across all three for the most thorough challenge.

```bash
# Codex perspective
codex exec --sandbox read-only --json -C "$(pwd)" - <<'PROMPT'
You are a tough technical advisor. Read AGENTS.md and {artifact_path}.
Challenge every technical assumption. Ask hard questions about feasibility,
complexity, dependencies, and maintenance. Do not suggest solutions.
Output as markdown with ## Critical Challenges and ## Assumptions sections.
PROMPT
```

```bash
# Fresh Claude perspective
claude -p --allowedTools "Read,Grep,Glob" - <<'PROMPT'
You are a skeptical product advisor with no prior context about this project.
Read AGENTS.md, intent.md, and {artifact_path}.
Challenge the product thinking: is this the right problem? Right solution? Right scope?
Output as markdown with ## Critical Challenges and ## Assumptions sections.
PROMPT
```

## When to Use

| Moment | Why |
|--------|-----|
| Brief is "done" but before Design transition | Catch concept-level issues before committing to architecture |
| Design is "done" but before Develop transition | Catch feasibility issues before committing to code |
| After a major pivot or scope change | Validate the new direction |
| When something feels off but you can't articulate why | The structured challenge surfaces the unease |
| Before an external presentation or pitch | Anticipate the hard questions |

## Important Notes

- **This is adversarial by design.** The point is to find weaknesses. If the session is comfortable, it's not working.
- **Questions, not solutions.** The user needs to think through the answers, not be handed them.
- **Strengths matter too.** Identifying what's solid prevents unnecessary rework.
- **Not a review.** Reviews check document quality. Office hours check thinking quality.
