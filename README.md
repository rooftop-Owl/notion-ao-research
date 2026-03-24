# notion-ao-research

**Agent-Oriented Research Workflow Skills for Notion**

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)
[![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-green.svg)](https://github.com/rooftop-Owl/notion-ao-research/releases)
[![Platform: Any MCP Client](https://img.shields.io/badge/Platform-Any%20MCP%20Client-blue.svg)](https://modelcontextprotocol.io)
[![Skills: 4](https://img.shields.io/badge/Skills-4-orange.svg)](#skills)
[![Handbook: EN + KO](https://img.shields.io/badge/Handbook-EN%20%2B%20KO-purple.svg)](#handbook)

A skill package for AI agents that work with [Notion](https://notion.so) through the [Model Context Protocol](https://modelcontextprotocol.io). Includes 3 marketplace-format agent skills, a human-readable design handbook (English + 한국어), and a markdown formatting skill.

Works with any MCP-compatible agent platform — Claude Code, Cursor, Windsurf, or any other.

---

## Installation

### Claude Code (native plugin)

```bash
claude plugin marketplace add rooftop-Owl/notion-ao-research
claude plugin install notion-ao-research
```

### Skills CLI (npx)

```bash
npx --yes skills add rooftop-Owl/notion-ao-research
```

### Manual (any MCP-compatible platform)

```bash
git clone https://github.com/rooftop-Owl/notion-ao-research.git
# Copy skills/ directory into your agent's skill path
```

## Initial Configuration

After installation, connect the Notion MCP server and register your workspace. Full details in the [Setup Guide](./skills/notion-workspace/references/setup-guide.md).

> [!NOTE]
> Steps 1-2 require browser actions. Your agent can guide you through each step and take over from step 3 onward.

### For Humans

1. **Create a Notion integration** — go to [notion.so/my-integrations](https://www.notion.so/my-integrations), create an internal integration, copy the token (`ntn_...`)
2. **Grant page access** — open each Notion page/database → ••• → Add connections → select your integration
3. **Connect MCP** — pick your platform:
   - **Claude Code**: `claude mcp add notion -- npx -y @notionhq/notion-mcp-server` (set `NOTION_API_TOKEN` env var first)
   - **Cursor**: add to `.cursor/mcp.json`:
     ```json
     { "mcpServers": { "notion": { "command": "npx", "args": ["-y", "@notionhq/notion-mcp-server"], "env": { "NOTION_API_TOKEN": "${NOTION_API_TOKEN}" } } } }
     ```
   - **Other MCP clients**: see [setup guide](./skills/notion-workspace/references/setup-guide.md#3-connect-notion-mcp-to-your-agent-platform)
4. **Create workspace config** — copy the [template](./skills/notion-workspace/examples/workspace-config.md) to your project root as `NOTION_WORKSPACE.md` and fill in your database IDs

### For Agents

Tell your agent:

```
Set up Notion for this project.
```

The agent will load `notion-workspace`, walk you through token creation and page access (browser steps), then handle MCP connection, workspace config generation, and verification automatically. See the [Setup Guide](./skills/notion-workspace/references/setup-guide.md) for the full agent/human handoff protocol.

---

## Skills

| Skill | Triggers | What it does |
|-------|----------|-------------|
| [notion-workspace](./skills/notion-workspace/SKILL.md) | "set up Notion", "connect MCP", "workspace config" | Gateway: MCP setup, workspace registration, skill dispatch |
| [notion-research](./skills/notion-research/SKILL.md) | "add entry", "log experiment", "mark complete" | NL research operations — add/query/update across any database pattern |
| [notion-bulletin](./skills/notion-bulletin/SKILL.md) | "notion infra", "open issue", "skill maintenance" | Infrastructure maintenance gate for skill changes and issue tracking |
| [markdown-documentation](./skills/markdown-documentation/SKILL.md) | "write markdown", "format docs" | Markdown formatting reference (GFM, callouts, diagrams) |

## Quick Start

1. **Install** — Clone or `npx skills add` this repo
2. **Connect** — Add the Notion MCP server to your agent platform
3. **Register** — Create your workspace config file ([template](./skills/notion-workspace/examples/workspace-config.md))
4. **Operate** — Load the relevant skill and start using natural language

→ [Detailed setup guide](./skills/notion-workspace/references/setup-guide.md)

---

## Handbook

Human-readable guides for learning Notion workspace design. Available in English and 한국어.

### English

1. [Principles & Anti-Patterns](./handbook/en/principles-and-antipatterns.md) — The 3 rules that matter
2. [Design Methodology](./handbook/en/design-methodology.md) — Master tables, input sections, status lifecycles
3. [Formulas & Automation](./handbook/en/formulas-and-automation.md) — Formula 2.0 and automation patterns

### 한국어

1. [원칙과 안티패턴](./handbook/ko/principles-and-antipatterns.md) — 이쁜 쓰레기와 좋은 워크스페이스를 가르는 3가지 원칙
2. [설계 방법론](./handbook/ko/design-methodology.md) — 마스터 테이블, 인풋 섹션, 상태 라이프사이클
3. [수식과 자동화](./handbook/ko/formulas-and-automation.md) — Formula 2.0, 조건문, 자동화 패턴

---

## Platform Compatibility

These skills use standard [Notion MCP](https://mcp.notion.com) tool names and work with any MCP-compatible agent platform. No platform-specific dependencies in the core skills.

Platform-specific enhancements (astraeus, Cursor, etc.) are documented in [platform-integrations.md](./skills/notion-workspace/references/platform-integrations.md).

---

## Structure

```text
notion-ao-research/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── notion-workspace/           # Gateway: setup + config
│   │   ├── SKILL.md
│   │   ├── references/
│   │   │   ├── setup-guide.md
│   │   │   ├── workspace-config-spec.md
│   │   │   ├── platform-integrations.md
│   │   │   └── schema-design.md
│   │   └── examples/
│   │       └── workspace-config.md
│   ├── notion-research/            # NL research operations
│   │   ├── SKILL.md
│   │   ├── references/
│   │   │   ├── diary-interface.md
│   │   │   ├── multi-db-interface.md
│   │   │   ├── cross-db-workflow.md
│   │   │   ├── handoff-protocol.md
│   │   │   └── api-patterns.md
│   │   └── examples/
│   │       └── schema-template.sql
│   ├── notion-bulletin/            # Infrastructure gate
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── lifecycle-patterns.md
│   └── markdown-documentation/     # Markdown formatting (MIT)
│       ├── SKILL.md
│       ├── references/
│       └── templates/
├── handbook/
│   ├── README.md
│   ├── en/                         # English handbook
│   └── ko/                         # 한국어 핸드북
├── README.md
└── LICENSE                         # CC BY-NC-SA 4.0
```

---

## License

[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) — see [LICENSE](./LICENSE)

You may use, share, and adapt this work for **non-commercial purposes** with attribution. Derivatives must use the same license.

> `skills/markdown-documentation/` is third-party content under the [MIT License](https://opensource.org/licenses/MIT) (from [aj-geddes/useful-ai-prompts](https://github.com/aj-geddes/useful-ai-prompts)).
