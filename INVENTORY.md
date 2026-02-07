# Capability Registry Inventory

*Generated: 2026-02-07 08:52*

## Summary

**Total capabilities:** 48

| Type | Count |
|------|-------|
| agent | 1 |
| plugin | 22 |
| skill | 19 |
| tool | 6 |

| Source | Count |
|--------|-------|
| anthropic | 38 |
| internal | 10 |

## Agents

| Name | Source | Quality | Tags | Description |
|------|--------|---------|------|-------------|
| doc-mgr | internal | 90 | documentation, maintenance, validation, lifecycle, planning | Documentation Specialist Agent — plans, creates, validates, and maintains project documentation throughout the development lifecycle. Handles documentation audits, post-implementation docs, and knowledge alignment. |

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
| github-mcp | anthropic | 0 | mcp, github, vcs, code | GitHub MCP server — repo management, issues, PRs, code search |
| knowledge-base | internal | 95 | mcp, knowledge-base, semantic-search, content, intelligence | Knowledge Base MCP Server — semantic search, capture, query, and management of a personal knowledge base. Provides 16 tools for search, retrieval, backlog management, focus topics, and content lifecycle. |
| stripe-mcp | anthropic | 0 | mcp, stripe, payments, billing | Stripe MCP server — payments, subscriptions, billing management |
| supabase-mcp | anthropic | 0 | mcp, supabase, database, backend | Supabase MCP server — database management, auth, storage, edge functions |
| vercel-mcp | anthropic | 0 | mcp, vercel, deployment, infrastructure | Vercel MCP server — deployment management, project configuration, domains |

## Tags Index

- **adf**: adf-env, adf-review, adf-review, adf-server, adf-workflow, kb-manager
- **agent-sdk**: agent-sdk-dev
- **animation**: slack-gif-creator
- **architecture**: feature-dev
- **art**: algorithmic-art
- **artifacts**: web-artifacts-builder
- **auth**: supabase
- **authoring**: plugin-dev
- **automation**: claude-code-setup, code-review, commit-commands, hookify, link-triage, playwright
- **backend**: stripe, supabase, supabase-mcp
- **billing**: stripe, stripe-mcp
- **branding**: brand-guidelines
- **browser**: playwright
- **business**: internal-comms
- **canvas**: canvas-design
- **ci-cd**: commit-commands
- **claude-md**: claude-md-management
- **code**: github-mcp
- **code-navigation**: pyright-lsp, typescript-lsp
- **code-review**: code-review
- **collaboration**: doc-coauthoring
- **commands**: adf-review
- **communications**: internal-comms
- **components**: frontend-design
- **content**: knowledge-base, link-triage
- **content-pipeline**: kb-manager
- **context**: claude-md-management, context7
- **creative**: algorithmic-art, slack-gif-creator
- **css**: frontend-design, theme-factory
- **curation**: kb-manager
- **database**: supabase, supabase-mcp
- **deployment**: vercel, vercel-mcp
- **design**: brand-guidelines, canvas-design, frontend-design, theme-factory
- **development**: agent-sdk-dev, code-review, feature-dev, hookify, mcp-builder, plugin-dev, ralph-loop, skill-creator
- **diagnostics**: pyright-lsp, typescript-lsp
- **documentation**: claude-md-management, context7, doc-mgr
- **documents**: doc-coauthoring, docx, pdf, pptx, xlsx
- **docx**: docx
- **environment**: adf-env
- **external**: external-review
- **frontend**: frontend-design
- **generative**: algorithmic-art
- **gif**: slack-gif-creator
- **git**: commit-commands, github
- **github**: github, github-mcp
- **graphics**: canvas-design
- **guidance**: adf-workflow
- **guidelines**: brand-guidelines
- **hooks**: hookify, security-guidance
- **hosting**: vercel
- **html**: web-artifacts-builder
- **infrastructure**: vercel, vercel-mcp
- **intelligence**: kb-manager, knowledge-base
- **issues**: github
- **iteration**: ralph-loop
- **javascript**: web-artifacts-builder
- **knowledge-base**: kb-manager, knowledge-base
- **libraries**: context7
- **lifecycle**: doc-mgr
- **links**: link-triage
- **lsp**: pyright-lsp, typescript-lsp
- **maintenance**: adf-env, claude-md-management, doc-mgr
- **mcp**: adf-server, external-review, github, github-mcp, knowledge-base, mcp-builder, stripe, stripe-mcp, supabase, supabase-mcp, vercel, vercel-mcp
- **meta**: plugin-dev, skill-creator
- **multi-model**: external-review
- **onboarding**: claude-code-setup
- **orchestration**: adf-server, adf-workflow
- **p5js**: algorithmic-art
- **payments**: stripe, stripe-mcp
- **pdf**: pdf
- **pipeline**: link-triage
- **planning**: doc-mgr, feature-dev
- **plugins**: plugin-dev
- **pptx**: pptx
- **presentations**: pptx
- **pull-requests**: github
- **python**: agent-sdk-dev, pyright-lsp
- **qa**: webapp-testing
- **quality**: adf-review, code-review, ralph-loop
- **ralph-loop**: adf-review, adf-review
- **recommendations**: claude-code-setup
- **reference**: context7
- **review**: adf-review, adf-review, adf-server, external-review, ralph-loop
- **safety**: security-guidance
- **scaffolding**: agent-sdk-dev, hookify
- **security**: security-guidance
- **semantic-search**: knowledge-base
- **session-discipline**: adf-env
- **setup**: claude-code-setup
- **skills**: plugin-dev, skill-creator
- **slack**: slack-gif-creator
- **source-control**: github
- **specs**: adf-server
- **spreadsheets**: xlsx
- **stages**: adf-workflow
- **storage**: supabase
- **stripe**: stripe, stripe-mcp
- **supabase**: supabase, supabase-mcp
- **synthesis**: kb-manager
- **testing**: playwright, webapp-testing
- **themes**: theme-factory
- **tools**: mcp-builder
- **triage**: link-triage
- **type-checking**: pyright-lsp
- **typescript**: agent-sdk-dev, typescript-lsp
- **ui**: canvas-design, frontend-design, theme-factory
- **validation**: adf-env, adf-review, adf-review, adf-server, doc-mgr, external-review, security-guidance
- **vcs**: github-mcp
- **vercel**: vercel, vercel-mcp
- **web**: playwright, web-artifacts-builder, webapp-testing
- **word**: docx
- **workflow**: adf-workflow, commit-commands, feature-dev
- **writing**: doc-coauthoring, internal-comms
- **xlsx**: xlsx
