# notion-ao-research

**Agent-Oriented Research Workflow Skills for Notion**

A family of 3 marketplace-format skills for [Notion MCP](https://mcp.notion.com) integration.
Works with any MCP-compatible agent platform — Claude Code, Cursor, Windsurf, or any other.

## Skills

| Skill | Triggers | What it does |
|-------|----------|-------------|
| [notion-workspace](./notion-workspace/SKILL.md) | "set up Notion", "connect Notion MCP", "workspace config", "getting started" | Gateway skill: establishes MCP connectivity, initializes workspace config, and dispatches to the correct notion-* skill |
| [notion-research](./notion-research/SKILL.md) | "add entry", "log experiment", "add paper", "mark complete", "what's on today" | Natural-language research operations with runtime database routing for add/query/update patterns |
| [notion-bulletin](./notion-bulletin/SKILL.md) | "notion infra", "bulletin board", "open issue", "skill maintenance" | Infrastructure maintenance gate for notion-* skill changes, issue tracking, and architecture toggle updates |

## Quick Start

1. **Connect** — Add the Notion MCP server to your agent platform
2. **Register** — Create or generate your workspace configuration file
3. **Operate** — Load the relevant skill and start using natural language

→ See [notion-workspace/references/setup-guide.md](./notion-workspace/references/setup-guide.md) for detailed setup.

## Platform Compatibility

These skills use standard [Notion MCP](https://mcp.notion.com) tool names and work with any
MCP-compatible agent platform. No platform-specific dependencies in the core skills.
Platform-specific enhancements are documented in [notion-workspace/references/platform-integrations.md](./notion-workspace/references/platform-integrations.md).

## Structure

```text
notion-ao-research/
├── notion-workspace/
│   ├── SKILL.md
│   ├── examples/
│   │   └── workspace-config.md
│   └── references/
│       ├── setup-guide.md
│       ├── workspace-config-spec.md
│       └── platform-integrations.md
├── notion-research/
│   ├── SKILL.md
│   ├── examples/
│   │   └── schema-template.sql
│   └── references/
│       ├── diary-interface.md
│       ├── multi-db-interface.md
│       ├── cross-db-workflow.md
│       ├── handoff-protocol.md
│       └── api-patterns.md
├── notion-bulletin/
│   ├── SKILL.md
│   └── references/
│       └── lifecycle-patterns.md
├── README.md
└── LICENSE
```

## License

MIT — see [LICENSE](./LICENSE)
