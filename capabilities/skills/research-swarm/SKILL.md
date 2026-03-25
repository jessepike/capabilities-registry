---
name: research-swarm
description: This skill spawns parallel research agents to deeply investigate a topic, technology, market, or problem space before planning or building. It should be used when the user wants to research before deciding, investigate options, compare approaches, do market research, find best practices, or validate assumptions. Trigger on phrases like "research this", "investigate options for", "what's the best approach to", "compare alternatives", "look into", "do some research on", "what's out there for", "validate this assumption", or during Discover stage when the brief needs grounding in external knowledge.
---

# Research Swarm

Spawn parallel research agents to investigate a topic from multiple angles simultaneously. Returns consolidated findings in minutes, not hours.

## Why Parallel Research

Sequential research is slow — you look at one thing, then the next, then the next. A swarm launches 4-6 research agents simultaneously, each investigating from a different angle. They all return findings, which get consolidated into a single brief.

This is the pattern that makes CE's `/ce:plan` effective — parallel research grounding before any planning happens.

## How It Works

When triggered, identify the research question and spawn agents for relevant angles. Not every research task needs all angles — pick the ones that matter.

### Available Research Angles

| Agent | What It Investigates | When to Use |
|-------|---------------------|-------------|
| **Market/Landscape** | Existing solutions, competitors, market size, who's doing this | Product concepts, new features, build-vs-buy decisions |
| **Technical** | Architecture patterns, frameworks, libraries, performance benchmarks | Tech stack decisions, implementation approaches |
| **Best Practices** | Industry standards, proven patterns, common pitfalls | Workflow design, process decisions, compliance |
| **Community** | Recent discussions, opinions, experiences from practitioners | Evaluating tools, understanding adoption, finding gotchas |
| **Regulatory/Compliance** | Legal requirements, standards, certifications, funding rules | Anything touching finance, health, government, data privacy |
| **Codebase** | Existing patterns in your code, prior decisions, related implementations | Understanding what you already have before building more |

### Execution

For each relevant angle, spawn a background Agent:

```
Agent(description: "Research: {angle} for {topic}")
```

Each agent should:
1. Search the web for recent, relevant information (WebSearch + WebFetch)
2. Check the knowledge base for prior research on this topic (if KB MCP is available)
3. Synthesize findings into a structured summary
4. Flag confidence level: High (multiple corroborating sources), Medium (limited sources), Low (speculation/thin evidence)

### Consolidation

After all agents return:

1. **Merge findings** by theme (not by agent)
2. **Identify agreements** — things multiple agents found independently (high confidence)
3. **Flag conflicts** — contradictory findings that need human judgment
4. **Extract decisions** — specific choices the findings inform
5. **List unknowns** — what the research couldn't answer

### Output Format

```markdown
## Research Summary: {topic}

**Date:** {today}
**Agents:** {count} parallel, {duration}
**Confidence:** {High/Medium/Low}

### Key Findings
- {finding 1 — with source}
- {finding 2 — with source}

### Landscape
{who's doing what, what solutions exist}

### Technical Considerations
{architecture patterns, framework options, performance notes}

### Best Practices
{industry standards, proven patterns, common pitfalls}

### Regulatory/Compliance
{relevant requirements, if applicable}

### Decisions This Informs
- {decision 1}: {finding suggests X because Y}
- {decision 2}: {options are A, B, C — finding favors B}

### Open Questions
- {what couldn't be answered — needs human investigation or direct outreach}

### Sources
- {url 1} — {what it contributed}
- {url 2} — {what it contributed}
```

## Stage-Specific Usage

| Stage | Typical Research Topics |
|-------|----------------------|
| **Discover** | Market landscape, existing solutions, regulatory requirements, user needs validation, funding sources |
| **Design** | Architecture patterns, framework comparisons, API design approaches, data model patterns |
| **Develop** | Library comparisons, performance benchmarks, testing strategies, deployment options |
| **Deliver** | Deployment platforms, CI/CD approaches, monitoring tools, access management |

## Integration with Knowledge Base

If the KB MCP is available:
- **Before researching:** Search KB for prior research on the same or related topics. Don't duplicate work.
- **After researching:** Save key findings to KB as extractions with `content_type: learning` and relevant topics. Future research swarms will find them.

## Important Notes

- **Spawn agents in parallel** — the whole point is speed. Don't run them sequentially.
- **Each agent gets a focused prompt** — don't give one agent all angles. Focused agents produce better results.
- **Confidence levels matter** — a finding from one blog post is not the same as a finding corroborated by 5 sources. Be explicit.
- **Recent sources preferred** — for technology topics, prioritize sources from the last 6 months. The field moves fast.
- **Save to KB** — findings that cost time to discover should be preserved for future use.
