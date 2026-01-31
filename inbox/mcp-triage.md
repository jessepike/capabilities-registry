# MCP Server Triage

Last scanned: 2026-01-31

## Sources

| Source | Last Checked | Status |
|--------|-------------|--------|
| registry.modelcontextprotocol.io | 2026-01-31 | Partial (dynamic API, no static listing) |
| github.com/wong2/awesome-mcp-servers | 2026-01-31 | Scanned (500+ servers) |
| mcpmarket.com | 2026-01-31 | Rate limited (429) |

## New Discoveries

From awesome-mcp-servers (sample of 500+ total):

| Name | Source | Description | Relevance |
|------|--------|-------------|-----------|
| Apify | community | Access 3,000+ pre-built cloud tools for data extraction | Low — no scraping workflows currently |
| AgentQL | community | Extract structured data from unstructured web content | Low — no web scraping projects |
| Aiven | community | Navigate PostgreSQL, Kafka, ClickHouse services | Low — no Aiven usage |
| Apache Doris | community | MPP-based real-time data warehouse | Low — no data warehouse projects |
| APIMatic | community | Validate OpenAPI specifications | Medium — useful for API projects |

Note: The vast majority of the 500+ servers are niche or domain-specific. No high-relevance discoveries for current project portfolio (ACM framework, capabilities registry, link-triage pipeline).

## Already Known/Declined

- **Registered (plugin-bundled):** github-mcp, supabase-mcp, stripe-mcp, vercel-mcp
- **Declined:** fetch-mcp, git-mcp, time-mcp, memory-mcp, filesystem-mcp, everything-mcp, sequentialthinking-mcp

## Top Recommendations

None at this time. Current MCP needs are covered by plugin-bundled servers. Revisit when new projects require external service integrations.

## Scan Summary

- Official Registry: Dynamic API, could not enumerate statically. Needs API endpoint discovery.
- Awesome MCP Servers: ~500+ servers scanned. 0 high-relevance, 1 medium-relevance (APIMatic).
- MCP Market: Rate limited, scan incomplete. Retry next cycle.
