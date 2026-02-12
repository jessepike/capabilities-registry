# Capability Registry Inventory

*Generated: 2026-02-12 14:17*

## Summary

**Total capabilities:** 72

| Type | Count |
|------|-------|
| agent | 17 |
| plugin | 23 |
| skill | 22 |
| tool | 10 |

| Source | Count |
|--------|-------|
| anthropic | 44 |
| community | 1 |
| internal | 27 |

## Client Enablement

| Client | Enabled | Disabled |
|--------|---------|----------|
| claude-code | 72 | 0 |
| claude-desktop | 9 | 63 |
| codex | 7 | 65 |
| gemini | 8 | 64 |

## Agents

| Name | Source | Quality | Tags | Description |
|------|--------|---------|------|-------------|
| agent-creator | anthropic | 95 | agent-creation, plugin-dev, configuration, automation | Agent Architect — translates user requirements into precisely-tuned agent specifications. Designs expert persona, comprehensive system prompts, optimal configuration (model, color, tools), and triggering examples. Generates complete agent .md files for Claude Code plugins. |
| code-architect | anthropic | 95 | architecture, design, blueprints, codebase-analysis, planning | Senior Software Architect Agent — analyzes existing codebase patterns and conventions, then delivers comprehensive implementation blueprints with specific files to create/modify, component designs, data flows, and build sequences. Makes decisive architectural choices with rationale. |
| code-explorer | anthropic | 95 | code-analysis, tracing, architecture, dependencies, exploration | Expert Code Analyst Agent — traces execution paths, maps architecture layers, understands patterns and abstractions, and documents dependencies to inform new development. Provides complete understanding of feature implementations from entry points to data storage through all layers. |
| code-reviewer | anthropic | 95 | code-review, security, quality, bugs, conventions | Expert Code Reviewer Agent — reviews code for bugs, logic errors, security vulnerabilities, and code quality issues using confidence-based filtering (only reports issues with confidence >= 80). Checks adherence to project conventions in CLAUDE.md. Groups findings by severity. |
| doc-mgr | internal | 90 | documentation, maintenance, validation, lifecycle, planning | Documentation Specialist Agent — plans, creates, validates, and maintains project documentation throughout the development lifecycle. Handles documentation audits, post-implementation docs, and knowledge alignment. |
| ecosystem-steward | internal | 90 | ecosystem, alignment, validation, cross-project, drift-detection, stewardship, adf | Ecosystem Steward Agent — responsible for cross-project alignment across the ADF ecosystem. Runs 6 alignment checks (governing docs, interface contracts, dependency chain, terminology, intent, decisions), produces structured reports with severity-rated findings, and proposes backlog items routed to the correct project. Supports full audit, targeted check, drift scan, and follow-up modes. |
| improver | internal | 90 | improvement, learning, cross-cutting, patterns, optimization, architecture | Cross-cutting Improvement Team agent — identifies improvement opportunities from patterns across completed work, KB, memory, and operational data. Produces improvement proposals as backlog items. Part of the Improvement Team defined in the Agentic Work System Architecture. Does NOT execute improvements — it proposes them. Does NOT assess current quality (that's the reviewer) or verify completion (that's the validator). Focuses on "how do we get better?" |
| kb-manager | internal | 90 | knowledge-base, digest, curation, synthesis, recommendations, content | KB Intelligence Agent — provides digest, curation, synthesis, recommendation, and content pipeline assessment services over the Knowledge Base. Consumes 16 KB MCP tools as a client. Supports 5 modes: DIGEST (activity dashboard), CURATE (health audit), SYNTHESIZE (combine related entries), RECOMMEND (project-relevant entries), and CONTENT (publication readiness assessment). |
| orchestrator | internal | 90 | orchestration, execution, planning, parallel, coordination, adf | Execute-Plan Orchestrator — phase-level execution coordinator that parses plan.md and tasks.md, spawns 3-5 parallel task-executor agents per phase, monitors progress via TaskList, invokes ralph-loop at phase boundaries, and validates exit criteria via phase-validator. Manages fix tasks, run logs, checkpoints, and session logs. |
| phase-validator | internal | 90 | validation, exit-criteria, testing, execution, quality-gates | Execute-Plan Phase Validator — exit criteria checker that parses criteria from plan.md, categorizes by type (test-based, execution-based, artifact-based, manual review), runs validation checks, and generates structured pass/fail reports for the orchestrator. |
| planner | internal | 90 | planning, decomposition, parallelization, capability-assessment, cross-cutting, architecture | Planning Agent — implements the ADF-PLANNING-SPEC methodology. Decomposes intent into executable work organized for parallel execution by agents with verified capabilities. Runs the seven-step planning process: understand intent, decompose into work units, organize phases, parallelization strategy, capability assessment (hard gate), testing strategy, risk/contingency. Produces plan.md and tasks.md drafts. Subordinate to Work Manager in the Work Management hierarchy. |
| plugin-validator | anthropic | 95 | plugin-validation, structure, configuration, security, quality | Plugin Validation Specialist Agent — comprehensive validation of Claude Code plugin structure, plugin.json manifest, component files (commands, agents, skills, hooks), naming conventions, MCP configuration, file organization, and security. Produces structured validation reports with severity-rated findings. |
| project-init | internal | 90 | project-init, scaffolding, adf, bootstrap, git, structure | ADF Project Initialization Agent — bootstraps ADF project structure from an existing concept brief. Creates folders, moves files, configures git, drafts initial intent.md from brief content, and validates structure. Infrastructure setup and initial intent extraction only — does not do full Discover stage work. |
| reviewer | internal | 90 | review, quality, cross-cutting, gap-analysis, feedback, architecture | Cross-cutting Review Team agent — quality assessment for any artifact across any project or domain. Evaluates plans, designs, code, briefs, and other artifacts against quality standards. Provides structured feedback with severity-rated findings (Critical/High/Low). Part of the Review Team defined in the Agentic Work System Architecture. Dispatched by orchestrators, Work Manager, or humans with artifact + review criteria as input. Does NOT verify completion (that's the validator). Focuses on "is this good?" not "is this done?" |
| skill-reviewer | anthropic | 95 | skill-review, quality, description, progressive-disclosure | Skill Quality Reviewer Agent — reviews and improves Claude Code skills for structure quality, description triggering effectiveness, progressive disclosure implementation, content organization, and adherence to best practices. Provides severity-rated findings with specific fix recommendations. |
| task-executor | internal | 90 | execution, tdd, implementation, testing, commits, worker | Execute-Plan Task Executor — task-level worker agent that receives 1-4 assigned tasks from the orchestrator, implements changes, validates acceptance criteria, and commits atomically. Supports TDD workflow (write tests first, red-green cycle) from Phase 5 onward. |
| validator | internal | 90 | validation, completion, drift-detection, cross-cutting, criteria-checking, architecture | Cross-cutting Validation Team agent — completion verification and drift detection for any work across any project or domain. Checks current state against target state (acceptance criteria, checklists, exit criteria). Produces structured pass/fail reports. Part of the Validation Team defined in the Agentic Work System Architecture. Does NOT assess quality (that's the reviewer). Focuses on "is this done?" not "is this good?" |

## Plugins

| Name | Source | Quality | Tags | Description |
|------|--------|---------|------|-------------|
| adf-env | internal | 100 | environment, maintenance, validation, adf, session-discipline | ADF Environment Manager — manages Claude Code environment across user and project layers, validates session discipline, runs health checks |
| adf-review | internal | 100 | review, adf, validation, commands, ralph-loop | ADF Review Plugin — provides slash commands for artifact reviews (/adf-review:artifact, /adf-review:artifact-internal, /adf-review:artifact-external). Wraps the adf-review skill with convenient command interface. |
| agent-sdk-dev | anthropic | 85 | agent-sdk, development, scaffolding, python, typescript | Claude Agent SDK development kit — scaffolding, verifier agents for Python and TypeScript SDK projects |
| claude-code-setup | anthropic | 90 | setup, automation, recommendations, onboarding | Analyze codebases and recommend Claude Code automations — hooks, skills, MCP servers, plugins |
| claude-md-management | anthropic | 90 | context, documentation, maintenance, claude-md | Audit, improve, and maintain CLAUDE.md files across repositories |
| code-review | anthropic | 90 | code-review, quality, development, automation | Automated code review — analyzes code for quality, patterns, and issues with specialized review agents |
| commit-commands | anthropic | 90 | git, workflow, automation, ci-cd | Git workflow automation — commit, push, open PRs, and clean up gone branches |
| context7 | anthropic | 85 | documentation, libraries, reference, context | Retrieve up-to-date documentation and code examples for any programming library via Context7 |
| ecosystem-alignment | internal | 90 | ecosystem, alignment, validation, cross-project, drift-detection, adf, integration | Ecosystem Steward — monitors cross-project alignment across the ADF ecosystem, detects drift between interrelated systems (ADF, Work OS, Krypton, KB, Memory Layer), and recommends corrective actions. Provides /ecosystem:audit command and ecosystem-steward agent for full audits, targeted checks, drift scans, and follow-up tracking. |
| feature-dev | anthropic | 85 | development, workflow, architecture, planning | Guided feature development workflow — clarifying questions, codebase analysis, architecture review before implementation |
| github | anthropic | 85 | github, git, mcp, source-control, issues, pull-requests | GitHub MCP server integration — issues, PRs, repos, code search via GitHub API |
| hookify | anthropic | 85 | hooks, automation, development, scaffolding | Custom hook creation helper — scaffolds PreToolUse, PostToolUse, and other event-driven hooks |
| kb-manager | internal | 95 | knowledge-base, intelligence, curation, synthesis, content-pipeline, adf | Knowledge Base Intelligence Layer — digest, curate, synthesize, recommend, and manage content pipeline from KB data. Provides slash commands (/kb:digest, /kb:curate, /kb:recommend, /kb:capture) and a kb-manager agent. |
| link-triage | internal | 90 | pipeline, triage, links, content, automation | Link Triage Pipeline — operate the link triage pipeline with run, backfill, status check, and collection listing. Project-scoped plugin for the link-triage-pipeline repo. |
| playwright | anthropic | 90 | browser, automation, testing, web | Browser automation via Playwright — navigate, click, fill forms, take screenshots, run code snippets |
| plugin-dev | anthropic | 90 | development, plugins, skills, meta, authoring | End-to-end plugin development — create plugins, skills, agents, hooks, commands, and MCP integrations |
| pyright-lsp | anthropic | 80 | lsp, python, diagnostics, code-navigation, type-checking | Python Language Server Protocol via Pyright — auto-diagnostics, type checking, go-to-definition, find references |
| ralph-loop | anthropic | 85 | review, iteration, development, quality | Iterative development loop — structured review cycles for refining code and artifacts |
| security-guidance | anthropic | 90 | security, hooks, validation, safety | PreToolUse security hook — detects command injection, XSS, eval, pickle deserialization, and other dangerous patterns |
| stripe | anthropic | 85 | payments, stripe, mcp, backend, billing | Stripe payments integration via bundled MCP server — payment processing, subscriptions, billing |
| supabase | anthropic | 85 | database, backend, supabase, mcp, auth, storage | Supabase integration via bundled MCP server — database queries, auth, storage, edge functions |
| typescript-lsp | anthropic | 75 | lsp, typescript, diagnostics, code-navigation | TypeScript Language Server Protocol — auto-diagnostics after edits, go-to-definition, find references, type info |
| vercel | anthropic | 85 | deployment, vercel, mcp, infrastructure, hosting | Vercel deployment integration via MCP server — deployments, projects, environment variables, logs |

## Skills

| Name | Source | Quality | Tags | Description |
|------|--------|---------|------|-------------|
| adf-review | internal | 100 | review, adf, validation, quality, ralph-loop | ADF Review Skill — orchestrates two-phase artifact reviews (internal Ralph Loop + external multi-model). Unified entry point for all ADF review processes. |
| adf-workflow | internal | 100 | workflow, adf, orchestration, stages, guidance | ADF Workflow Skill — companion skill that teaches agents when and how to use ADF MCP server tools. Provides narrative workflow instructions for stage transitions, reviews, and artifact management. |
| adr | internal | 100 | adr, adf, decisions, architecture, governance, documentation | ADR Skill — manages Architecture Decision Records as ADF decision-type artifacts. Supports create (auto-numbering, template), list (status table), update-status (with archive moves), and link (connect to design.md Decision Log) workflows. |
| algorithmic-art | anthropic | 100 | art, generative, p5js, creative | Creating algorithmic art using p5.js with seeded randomness and interactive |
| brand-guidelines | anthropic | 100 | design, branding, guidelines | Applies Anthropic's official brand colors and typography to any sort |
| canvas-design | anthropic | 100 | ui, design, canvas, graphics | Create beautiful visual art in .png and .pdf documents using design philosophy. |
| doc-coauthoring | anthropic | 100 | documents, writing, collaboration | Guide users through a structured workflow for co-authoring documentation. |
| docx | anthropic | 100 | documents, docx, word | 'Comprehensive document creation, editing, and analysis with support |
| external-review | internal | 100 | review, mcp, external, multi-model, validation | External Review MCP Server — sends artifacts to external LLM models (GPT, Gemini, Kimi) for independent review. Provides list_models and review tools with parallel execution and cost tracking. |
| frontend-design | anthropic | 100 | ui, frontend, design, css, components | Create distinctive, production-grade frontend interfaces with high design |
| internal-comms | anthropic | 100 | writing, communications, business | A set of resources to help me write all kinds of internal communications, |
| mcp-builder | anthropic | 100 | mcp, development, tools | Guide for creating high-quality MCP (Model Context Protocol) servers |
| pdf | anthropic | 100 | documents, pdf | Comprehensive PDF manipulation toolkit for extracting text and tables, |
| pptx | anthropic | 100 | documents, pptx, presentations | 'Presentation creation, editing, and analysis. When Claude needs to work |
| project-health | internal | 100 | health, audit, testing, dependencies, security, code-hygiene, adf, secrets, design-drift, documentation | Project Health Auditor — code-level health auditing with 19 checks across 6 categories (test health, dependency health, code hygiene, secrets & config, build-to-design drift, documentation sync). Complements adf-env (governance layer) and adf-review (artifact quality). Supports Python, TypeScript, Go, Rust with auto-detection and stage-aware check selection. |
| security-review | internal | 100 | security, owasp, injection, xss, ssrf, cryptography, supply-chain, threat-model, audit, adf | Security Review — code-level and design-level security analysis with 22 checks across 5 categories (injection & input validation, cryptography, unsafe operations, supply chain, design security posture). Complements project-health (secrets, CVEs) and security-guidance (runtime prevention). Supports Python, TypeScript, Go, Rust with auto-detection, stage-aware check selection, and OWASP pattern matching. |
| skill-creator | anthropic | 100 | development, skills, meta | Guide for creating effective skills. This skill should be used when users |
| slack-gif-creator | anthropic | 100 | slack, gif, animation, creative | Knowledge and utilities for creating animated GIFs optimized for Slack. |
| theme-factory | anthropic | 100 | ui, design, themes, css | Toolkit for styling artifacts with a theme. These artifacts can be slides, |
| web-artifacts-builder | anthropic | 100 | web, artifacts, html, javascript | Suite of tools for creating elaborate, multi-component claude.ai HTML |
| webapp-testing | anthropic | 100 | testing, web, qa | Toolkit for interacting with and testing local web applications using |
| xlsx | anthropic | 100 | documents, xlsx, spreadsheets | 'Comprehensive spreadsheet creation, editing, and analysis with support |

## Tools

| Name | Source | Quality | Tags | Description |
|------|--------|---------|------|-------------|
| adf-server | internal | 100 | mcp, adf, orchestration, specs, review, validation | ADF MCP Server — read-only interface to ADF specs, prompts, stubs, knowledge base, and capabilities registry. Provides tools for stage workflow, review prompts, artifact specs, project validation. |
| diagram-forge | internal | 95 | mcp, diagrams, architecture, visualization, ai-image-generation, design | Diagram Forge MCP Server — generates enterprise-grade architecture diagrams from natural language using template-driven prompt engineering and AI image providers (Google Gemini, OpenAI GPT Image, Replicate Flux). Provides 7 diagram templates (architecture, data flow, component, sequence, integration, infographic, generic), style references, and cost tracking. Includes Claude Code plugin with guided commands and context-gatherer agent. |
| github-mcp | anthropic | 0 | mcp, github, vcs, code | GitHub MCP server — repo management, issues, PRs, code search |
| knowledge-base | internal | 95 | mcp, knowledge-base, semantic-search, content, intelligence | Knowledge Base MCP Server — semantic search, capture, query, and management of a personal knowledge base. Provides 16 tools for search, retrieval, backlog management, focus topics, and content lifecycle. |
| memory-layer | internal | 95 | mcp, memory, context, retrieval, sqlite, chroma | Memory Layer MCP Server — persistent contextual memory service with namespace-scoped write/search/update/archive flows, review candidates, stats, reconciliation, and failed-memory lifecycle tools. |
| stitch-mcp | community | 85 | mcp, ui, design, frontend, google, code-generation, stitch | Google Stitch MCP Server — official remote MCP server for AI-powered UI/UX design generation. Provides 6 tools: create projects, generate screens from text prompts, list/get projects and screens. Outputs HTML/Tailwind CSS designs convertible to React, Vue, Flutter, etc. Hosted by Google at stitch.googleapis.com/mcp. Auth via API key or OAuth. |
| stripe-mcp | anthropic | 0 | mcp, stripe, payments, billing | Stripe MCP server — payments, subscriptions, billing management |
| supabase-mcp | anthropic | 0 | mcp, supabase, database, backend | Supabase MCP server — database management, auth, storage, edge functions |
| vercel-mcp | anthropic | 0 | mcp, vercel, deployment, infrastructure | Vercel MCP server — deployment management, project configuration, domains |
| work-management-mcp | internal | 100 | work-management, mcp, tools, projects, tasks | MCP server for Work Management system, providing project and task tools. |

## Tags Index

- **adf**: adf-env, adf-review, adf-review, adf-server, adf-workflow, adr, ecosystem-alignment, ecosystem-steward, kb-manager, orchestrator, project-health, project-init, security-review
- **adr**: adr
- **agent-creation**: agent-creator
- **ai-image-generation**: diagram-forge
- **agent-sdk**: agent-sdk-dev
- **alignment**: ecosystem-alignment, ecosystem-steward
- **animation**: slack-gif-creator
- **architecture**: adr, code-architect, code-explorer, diagram-forge, feature-dev, improver, planner, reviewer, validator
- **art**: algorithmic-art
- **artifacts**: web-artifacts-builder
- **audit**: project-health, security-review
- **auth**: supabase
- **authoring**: plugin-dev
- **automation**: agent-creator, claude-code-setup, code-review, commit-commands, hookify, link-triage, playwright
- **backend**: stripe, supabase, supabase-mcp
- **billing**: stripe, stripe-mcp
- **blueprints**: code-architect
- **bootstrap**: project-init
- **branding**: brand-guidelines
- **browser**: playwright
- **bugs**: code-reviewer
- **business**: internal-comms
- **canvas**: canvas-design
- **capability-assessment**: planner
- **chroma**: memory-layer
- **ci-cd**: commit-commands
- **claude-md**: claude-md-management
- **code**: github-mcp
- **code-analysis**: code-explorer
- **code-generation**: stitch-mcp
- **code-hygiene**: project-health
- **code-navigation**: pyright-lsp, typescript-lsp
- **code-review**: code-review, code-reviewer
- **codebase-analysis**: code-architect
- **collaboration**: doc-coauthoring
- **commands**: adf-review
- **commits**: task-executor
- **communications**: internal-comms
- **completion**: validator
- **components**: frontend-design
- **configuration**: agent-creator, plugin-validator
- **content**: kb-manager, knowledge-base, link-triage
- **content-pipeline**: kb-manager
- **context**: claude-md-management, context7, memory-layer
- **conventions**: code-reviewer
- **coordination**: orchestrator
- **creative**: algorithmic-art, slack-gif-creator
- **criteria-checking**: validator
- **cross-cutting**: improver, planner, reviewer, validator
- **cross-project**: ecosystem-alignment, ecosystem-steward
- **cryptography**: security-review
- **css**: frontend-design, theme-factory
- **curation**: kb-manager, kb-manager
- **database**: supabase, supabase-mcp
- **decisions**: adr
- **diagrams**: diagram-forge
- **decomposition**: planner
- **dependencies**: code-explorer, project-health
- **deployment**: vercel, vercel-mcp
- **description**: skill-reviewer
- **design**: brand-guidelines, canvas-design, code-architect, diagram-forge, frontend-design, stitch-mcp, theme-factory
- **design-drift**: project-health
- **development**: agent-sdk-dev, code-review, feature-dev, hookify, mcp-builder, plugin-dev, ralph-loop, skill-creator
- **diagnostics**: pyright-lsp, typescript-lsp
- **digest**: kb-manager
- **documentation**: adr, claude-md-management, context7, doc-mgr, project-health
- **documents**: doc-coauthoring, docx, pdf, pptx, xlsx
- **docx**: docx
- **drift-detection**: ecosystem-alignment, ecosystem-steward, validator
- **ecosystem**: ecosystem-alignment, ecosystem-steward
- **environment**: adf-env
- **execution**: orchestrator, phase-validator, task-executor
- **exit-criteria**: phase-validator
- **exploration**: code-explorer
- **external**: external-review
- **feedback**: reviewer
- **frontend**: frontend-design, stitch-mcp
- **gap-analysis**: reviewer
- **generative**: algorithmic-art
- **gif**: slack-gif-creator
- **git**: commit-commands, github, project-init
- **github**: github, github-mcp
- **google**: stitch-mcp
- **governance**: adr
- **graphics**: canvas-design
- **guidance**: adf-workflow
- **guidelines**: brand-guidelines
- **health**: project-health
- **hooks**: hookify, security-guidance
- **hosting**: vercel
- **html**: web-artifacts-builder
- **implementation**: task-executor
- **improvement**: improver
- **infrastructure**: vercel, vercel-mcp
- **injection**: security-review
- **integration**: ecosystem-alignment
- **intelligence**: kb-manager, knowledge-base
- **issues**: github
- **iteration**: ralph-loop
- **javascript**: web-artifacts-builder
- **knowledge-base**: kb-manager, kb-manager, knowledge-base
- **learning**: improver
- **libraries**: context7
- **lifecycle**: doc-mgr
- **links**: link-triage
- **lsp**: pyright-lsp, typescript-lsp
- **maintenance**: adf-env, claude-md-management, doc-mgr
- **mcp**: adf-server, diagram-forge, external-review, github, github-mcp, knowledge-base, mcp-builder, memory-layer, stitch-mcp, stripe, stripe-mcp, supabase, supabase-mcp, vercel, vercel-mcp, work-management-mcp
- **memory**: memory-layer
- **meta**: plugin-dev, skill-creator
- **multi-model**: external-review
- **onboarding**: claude-code-setup
- **optimization**: improver
- **orchestration**: adf-server, adf-workflow, orchestrator
- **owasp**: security-review
- **p5js**: algorithmic-art
- **parallel**: orchestrator
- **parallelization**: planner
- **patterns**: improver
- **payments**: stripe, stripe-mcp
- **pdf**: pdf
- **pipeline**: link-triage
- **planning**: code-architect, doc-mgr, feature-dev, orchestrator, planner
- **plugin-dev**: agent-creator
- **plugin-validation**: plugin-validator
- **plugins**: plugin-dev
- **pptx**: pptx
- **presentations**: pptx
- **progressive-disclosure**: skill-reviewer
- **project-init**: project-init
- **projects**: work-management-mcp
- **pull-requests**: github
- **python**: agent-sdk-dev, pyright-lsp
- **qa**: webapp-testing
- **quality**: adf-review, code-review, code-reviewer, plugin-validator, ralph-loop, reviewer, skill-reviewer
- **quality-gates**: phase-validator
- **ralph-loop**: adf-review, adf-review
- **recommendations**: claude-code-setup, kb-manager
- **reference**: context7
- **retrieval**: memory-layer
- **review**: adf-review, adf-review, adf-server, external-review, ralph-loop, reviewer
- **safety**: security-guidance
- **scaffolding**: agent-sdk-dev, hookify, project-init
- **secrets**: project-health
- **security**: code-reviewer, plugin-validator, project-health, security-guidance, security-review
- **semantic-search**: knowledge-base
- **session-discipline**: adf-env
- **setup**: claude-code-setup
- **skill-review**: skill-reviewer
- **skills**: plugin-dev, skill-creator
- **slack**: slack-gif-creator
- **source-control**: github
- **specs**: adf-server
- **spreadsheets**: xlsx
- **sqlite**: memory-layer
- **ssrf**: security-review
- **stages**: adf-workflow
- **stewardship**: ecosystem-steward
- **stitch**: stitch-mcp
- **storage**: supabase
- **stripe**: stripe, stripe-mcp
- **structure**: plugin-validator, project-init
- **supabase**: supabase, supabase-mcp
- **supply-chain**: security-review
- **synthesis**: kb-manager, kb-manager
- **tasks**: work-management-mcp
- **tdd**: task-executor
- **testing**: phase-validator, playwright, project-health, task-executor, webapp-testing
- **themes**: theme-factory
- **threat-model**: security-review
- **tools**: mcp-builder, work-management-mcp
- **tracing**: code-explorer
- **triage**: link-triage
- **type-checking**: pyright-lsp
- **typescript**: agent-sdk-dev, typescript-lsp
- **ui**: canvas-design, frontend-design, stitch-mcp, theme-factory
- **validation**: adf-env, adf-review, adf-review, adf-server, doc-mgr, ecosystem-alignment, ecosystem-steward, external-review, phase-validator, security-guidance, validator
- **visualization**: diagram-forge
- **vcs**: github-mcp
- **vercel**: vercel, vercel-mcp
- **web**: playwright, web-artifacts-builder, webapp-testing
- **word**: docx
- **work-management**: work-management-mcp
- **worker**: task-executor
- **workflow**: adf-workflow, commit-commands, feature-dev
- **writing**: doc-coauthoring, internal-comms
- **xlsx**: xlsx
- **xss**: security-review
