# Capability Registry Inventory

*Generated: 2026-01-30 09:43*

## Summary

**Total capabilities:** 39

| Type | Count |
|------|-------|
| plugin | 19 |
| skill | 16 |
| tool | 4 |

| Source | Count |
|--------|-------|
| anthropic | 34 |
| internal | 1 |
| modelcontextprotocol | 4 |

## Plugins

| Name | Source | Quality | Tags | Description |
|------|--------|---------|------|-------------|
| acm-env | internal | 100 | environment, maintenance, validation, acm | Agentic Development Environment Manager — manages Claude Code environment across user and project layers |
| agent-sdk-dev | anthropic | 85 | agent-sdk, development, scaffolding, python, typescript | Claude Agent SDK development kit — scaffolding, verifier agents for Python and TypeScript SDK projects |
| claude-code-setup | anthropic | 90 | setup, automation, recommendations, onboarding | Analyze codebases and recommend Claude Code automations — hooks, skills, MCP servers, plugins |
| claude-md-management | anthropic | 90 | context, documentation, maintenance, claude-md | Audit, improve, and maintain CLAUDE.md files across repositories |
| code-review | anthropic | 90 | code-review, quality, development, automation | Automated code review — analyzes code for quality, patterns, and issues with specialized review agents |
| commit-commands | anthropic | 90 | git, workflow, automation, ci-cd | Git workflow automation — commit, push, open PRs, and clean up gone branches |
| context7 | anthropic | 85 | documentation, libraries, reference, context | Retrieve up-to-date documentation and code examples for any programming library via Context7 |
| feature-dev | anthropic | 85 | development, workflow, architecture, planning | Guided feature development workflow — clarifying questions, codebase analysis, architecture review before implementation |
| github | anthropic | 85 | github, git, mcp, source-control, issues, pull-requests | GitHub MCP server integration — issues, PRs, repos, code search via GitHub API |
| hookify | anthropic | 85 | hooks, automation, development, scaffolding | Custom hook creation helper — scaffolds PreToolUse, PostToolUse, and other event-driven hooks |
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
| algorithmic-art | anthropic | 100 | art, generative, p5js, creative | Creating algorithmic art using p5.js with seeded randomness and interactive |
| brand-guidelines | anthropic | 100 | design, branding, guidelines | Applies Anthropic's official brand colors and typography to any sort |
| canvas-design | anthropic | 100 | ui, design, canvas, graphics | Create beautiful visual art in .png and .pdf documents using design philosophy. |
| doc-coauthoring | anthropic | 100 | documents, writing, collaboration | Guide users through a structured workflow for co-authoring documentation. |
| docx | anthropic | 100 | documents, docx, word | 'Comprehensive document creation, editing, and analysis with support |
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
| everything-mcp | modelcontextprotocol | 90 | mcp, testing, reference | MCP server that exercises all the features of the MCP protocol |
| filesystem-mcp | modelcontextprotocol | 75 | mcp, filesystem, io | MCP server for filesystem access |
| memory-mcp | modelcontextprotocol | 90 | mcp, memory, knowledge-graph | MCP server for enabling memory for Claude through a knowledge graph |
| sequentialthinking-mcp | modelcontextprotocol | 90 | mcp, reasoning, thinking | MCP server for sequential thinking and problem solving |

## Tags Index

- **acm**: acm-env
- **agent-sdk**: agent-sdk-dev
- **animation**: slack-gif-creator
- **architecture**: feature-dev
- **art**: algorithmic-art
- **artifacts**: web-artifacts-builder
- **auth**: supabase
- **authoring**: plugin-dev
- **automation**: claude-code-setup, code-review, commit-commands, hookify, playwright
- **backend**: stripe, supabase
- **billing**: stripe
- **branding**: brand-guidelines
- **browser**: playwright
- **business**: internal-comms
- **canvas**: canvas-design
- **ci-cd**: commit-commands
- **claude-md**: claude-md-management
- **code-navigation**: pyright-lsp, typescript-lsp
- **code-review**: code-review
- **collaboration**: doc-coauthoring
- **communications**: internal-comms
- **components**: frontend-design
- **context**: claude-md-management, context7
- **creative**: algorithmic-art, slack-gif-creator
- **css**: frontend-design, theme-factory
- **database**: supabase
- **deployment**: vercel
- **design**: brand-guidelines, canvas-design, frontend-design, theme-factory
- **development**: agent-sdk-dev, code-review, feature-dev, hookify, mcp-builder, plugin-dev, ralph-loop, skill-creator
- **diagnostics**: pyright-lsp, typescript-lsp
- **documentation**: claude-md-management, context7
- **documents**: doc-coauthoring, docx, pdf, pptx, xlsx
- **docx**: docx
- **environment**: acm-env
- **filesystem**: filesystem-mcp
- **frontend**: frontend-design
- **generative**: algorithmic-art
- **gif**: slack-gif-creator
- **git**: commit-commands, github
- **github**: github
- **graphics**: canvas-design
- **guidelines**: brand-guidelines
- **hooks**: hookify, security-guidance
- **hosting**: vercel
- **html**: web-artifacts-builder
- **infrastructure**: vercel
- **io**: filesystem-mcp
- **issues**: github
- **iteration**: ralph-loop
- **javascript**: web-artifacts-builder
- **knowledge-graph**: memory-mcp
- **libraries**: context7
- **lsp**: pyright-lsp, typescript-lsp
- **maintenance**: acm-env, claude-md-management
- **mcp**: everything-mcp, filesystem-mcp, github, mcp-builder, memory-mcp, sequentialthinking-mcp, stripe, supabase, vercel
- **memory**: memory-mcp
- **meta**: plugin-dev, skill-creator
- **onboarding**: claude-code-setup
- **p5js**: algorithmic-art
- **payments**: stripe
- **pdf**: pdf
- **planning**: feature-dev
- **plugins**: plugin-dev
- **pptx**: pptx
- **presentations**: pptx
- **pull-requests**: github
- **python**: agent-sdk-dev, pyright-lsp
- **qa**: webapp-testing
- **quality**: code-review, ralph-loop
- **reasoning**: sequentialthinking-mcp
- **recommendations**: claude-code-setup
- **reference**: context7, everything-mcp
- **review**: ralph-loop
- **safety**: security-guidance
- **scaffolding**: agent-sdk-dev, hookify
- **security**: security-guidance
- **setup**: claude-code-setup
- **skills**: plugin-dev, skill-creator
- **slack**: slack-gif-creator
- **source-control**: github
- **spreadsheets**: xlsx
- **storage**: supabase
- **stripe**: stripe
- **supabase**: supabase
- **testing**: everything-mcp, playwright, webapp-testing
- **themes**: theme-factory
- **thinking**: sequentialthinking-mcp
- **tools**: mcp-builder
- **type-checking**: pyright-lsp
- **typescript**: agent-sdk-dev, typescript-lsp
- **ui**: canvas-design, frontend-design, theme-factory
- **validation**: acm-env, security-guidance
- **vercel**: vercel
- **web**: playwright, web-artifacts-builder, webapp-testing
- **word**: docx
- **workflow**: commit-commands, feature-dev
- **writing**: doc-coauthoring, internal-comms
- **xlsx**: xlsx
