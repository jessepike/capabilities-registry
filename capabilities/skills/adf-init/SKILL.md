---
name: adf-init
description: This skill scaffolds a new ADF project with folder structure, root artifacts, and dual-runtime support (Claude + Codex). It should be used whenever the user wants to create a new project, initialize a repository, set up a new codebase, scaffold project structure, or bootstrap a fresh repo. Trigger on phrases like "new project", "init project", "scaffold", "set up a new repo", "bootstrap", "start a new project", or "create project structure". Also use when the user is in an empty or near-empty directory and wants to start building something.
---

# ADF Project Init

Scaffold an ADF-compliant project with the correct folder structure, root artifacts, governance layer, and dual-runtime instruction files.

## Workflow

### 1. Gather Project Info

Collect three things before scaffolding. If the user has already provided context (e.g., "set up a new Next.js app for my portfolio"), extract what you can and confirm the rest.

**Required:**
- **Project name** — used in artifact headers and README
- **Project type** — determines folder structure additions

**Type selection — ask "What kind of thing are we making?"**

| Answer | Type |
|--------|------|
| "A document or file — done when delivered" | **Artifact** |
| "Software that runs and has users" | **App** |
| "A process or automation" | **Workflow** |

**Optional modifiers** (defaults in bold):

| Modifier | Options |
|----------|---------|
| Scale | **personal**, shared, community, commercial |
| Scope | **mvp**, full-build |
| Complexity | **standalone**, multi-component |

Classification syntax: `{Type} + {scale} + {scope} + {complexity}`
Example: `App + personal + mvp + standalone`

For hybrids (e.g., app + docs), pick the primary type for scaffolding.

### 2. Create Folder Structure

Initialize git if no `.git/` exists, then scaffold.

**Base structure (all projects):**

```bash
git init  # only if no .git/
mkdir -p .claude/rules docs/inbox docs/active docs/reference docs/archive .ctx/scratch .ctx/plans .ctx/research
touch AGENTS.md CLAUDE.md intent.md BACKLOG.md status.md decisions.md README.md .gitignore
echo ".ctx/" >> .gitignore
```

**Type-specific additions:**

| Type | Command |
|------|---------|
| App | `mkdir -p src tests config scripts && touch Makefile` |
| Artifact | `mkdir -p assets output` |
| Workflow | `mkdir -p workflows scripts` |

### 3. Populate Root Artifacts

Read `references/templates.md` for the full templates. Create each file with proper frontmatter and stub content. Key points:

- **AGENTS.md** — shared instructions for all runtimes (Claude + Codex). Contains project overview, build commands, conventions, ADF workflow rules. This is the primary instruction file.
- **CLAUDE.md** — thin wrapper. Starts with `@AGENTS.md` import, adds context map and Claude-specific notes only.
- **intent.md** — stub with three sections (Problem/Opportunity, Desired Outcome, Why It Matters). Marked as human-only.
- **BACKLOG.md** — empty queue and archive tables with proper column headers.
- **status.md** — initialized to Discover stage, first session log entry.
- **decisions.md** — empty table with Date, Decision, Rationale, Who columns.
- **README.md** — project name, one-line description, "Created with ADF" note.
- **.claude/rules/constraints.md** — starter constraints (no secrets in commits, no modifying intent.md without permission, confirm destructive ops).

### 4. Validate

Run through this checklist before finishing:

- [ ] `AGENTS.md` exists with project overview and ADF workflow section
- [ ] `CLAUDE.md` exists with `@AGENTS.md` import and context map
- [ ] `intent.md` exists (stub OK)
- [ ] `BACKLOG.md` exists with queue/archive tables
- [ ] `status.md` exists with stage set to Discover
- [ ] `decisions.md` exists (stub OK)
- [ ] `README.md` exists
- [ ] `.claude/rules/constraints.md` exists
- [ ] `docs/inbox/`, `docs/active/`, `docs/reference/`, `docs/archive/` exist
- [ ] `.ctx/` exists and is in `.gitignore`
- [ ] Type-specific folders created
- [ ] Classification recorded in AGENTS.md

### 5. Initial Commit

Stage all created files and commit:

```
feat(init): scaffold {project-name} as {Type} + {modifiers}
```

### 6. Report

Tell the user what was created. List the root artifacts and their purpose. Suggest next step: "You're in Discover stage. Start by filling out intent.md with your project's North Star, then work through brief.md in docs/active/."

## Important Notes

- **intent.md is immutable** — agents cannot modify it without explicit human permission. The stub makes this clear.
- **AGENTS.md gets the substance.** Most project instructions go here because both Claude and Codex read it. CLAUDE.md is a thin shell.
- **No stage-prefixed file names.** Files are named for what they are, not which stage created them (e.g., `brief.md` not `discover-brief.md`).
- **docs/active/ is the agent working zone.** When the user starts creating documents in Discover (brief, research), they go here.
- **.ctx/ is ephemeral scratch.** Gitignored. Agents use it for working notes, plans, research. Nothing load-bearing lives here.
