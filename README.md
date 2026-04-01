# notion-ao-research

**Agent-Oriented Research Workflow Skills for Notion**

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)
[![Version: 1.3.0](https://img.shields.io/badge/Version-1.3.0-green.svg)](https://github.com/rooftop-Owl/notion-ao-research/releases)
[![Platform: Any MCP Client](https://img.shields.io/badge/Platform-Any%20MCP%20Client-blue.svg)](https://modelcontextprotocol.io)
[![Skills: 7](https://img.shields.io/badge/Skills-7-orange.svg)](#skills)
[![Handbook: EN + KO](https://img.shields.io/badge/Handbook-EN%20%2B%20KO-purple.svg)](#handbook)

A skill package for AI agents that work with [Notion](https://notion.so) through the [Model Context Protocol](https://modelcontextprotocol.io). Includes 7 agent skills (4 Notion workflow + 3 research methodology), a human-readable design handbook (English + 한국어), and a markdown formatting skill.

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

After installation, connect the Notion MCP server and register your workspace. Full details in the [Setup Guide](./skills/notion-ao-workspace/references/setup-guide.md).

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
   - **Other MCP clients**: see [setup guide](./skills/notion-ao-workspace/references/setup-guide.md#3-connect-notion-mcp-to-your-agent-platform)
4. **Create workspace config** — copy the [template](./skills/notion-ao-workspace/examples/workspace-config.md) to your project root as `NOTION_WORKSPACE.md` and fill in your database IDs

### For Agents

Tell your agent:

```
Set up Notion for this project.
```

The agent will load `notion-ao-workspace`, walk you through token creation and page access (browser steps), then handle MCP connection, workspace config generation, and verification automatically. See the [Setup Guide](./skills/notion-ao-workspace/references/setup-guide.md) for the full agent/human handoff protocol.

---

## Skills

| Skill | When to load | What it does |
|-------|-------------|-------------|
| [notion-ao-workspace](./skills/notion-ao-workspace/SKILL.md) | First-time project setup, or if MCP connection needs reconfiguring | Gateway: MCP setup, workspace registration, routes to the right skill |
| [notion-ao-ops](./skills/notion-ao-ops/SKILL.md) | Any routine database op — "add entry", "log experiment", "mark complete" | NL → database operations: add/query/update across diary, milestones, experiments, papers, notes |
| [notion-ao-bulletin](./skills/notion-ao-bulletin/SKILL.md) | Modifying the Notion skill family itself (not for everyday research work) | Infrastructure gate: tracks open issues, logs enhancements, enforces session-close protocol |
| [notion-ao-markdown-documentation](./skills/notion-ao-markdown-documentation/SKILL.md) | Writing READMEs, docs, or formatting GFM — tables, callouts, diagrams, LaTeX | Complete GFM reference: alerts, collapsibles, Mermaid diagrams, LaTeX, code blocks |
| [notion-ao-project-context](./skills/notion-ao-project-context/SKILL.md) | Start of any research session — orients the agent to active priorities | Fetches the Project Hub page from Notion to surface current state before research tasks |
| [notion-ao-research-methodology](./skills/notion-ao-research-methodology/SKILL.md) | Literature work, citing sources, evaluating evidence, designing Two-Zone workspaces | Citation fidelity, calibrated uncertainty language, evidence quality tiers, Two-Zone model |
| [notion-ao-writing-conventions](./skills/notion-ao-writing-conventions/SKILL.md) | Finalizing manuscripts, polishing academic prose, enforcing consistent hedging language | Writing standards: uncertainty language, citation quality gates, document quality checklist |


## Quick Start

1. **Install** — Clone or `npx skills add` this repo
2. **Connect** — Add the Notion MCP server to your agent platform
3. **Register** — Create your workspace config file ([template](./skills/notion-ao-workspace/examples/workspace-config.md))
4. **Operate** — Load the relevant skill and start using natural language

→ [Detailed setup guide](./skills/notion-ao-workspace/references/setup-guide.md)

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

Platform-specific enhancements (astraeus, Cursor, etc.) are documented in [platform-integrations.md](./skills/notion-ao-workspace/references/platform-integrations.md).

---

## Structure

```text
notion-ao-research/
├── .claude-plugin/
│   ├── marketplace.json
│   └── plugin.json
├── skills/
│   ├── notion-ao-workspace/           # Gateway: setup + config
│   │   ├── SKILL.md
│   │   ├── references/
│   │   │   ├── setup-guide.md
│   │   │   ├── workspace-config-spec.md
│   │   │   ├── platform-integrations.md
│   │   │   └── schema-design.md
│   │   └── examples/
│   │       └── workspace-config.md
│   ├── notion-ao-ops/                 # NL research operations
│   │   ├── SKILL.md
│   │   ├── references/
│   │   │   ├── advanced-api.md
│   │   │   ├── api-patterns.md
│   │   │   ├── cross-db-workflow.md
│   │   │   ├── diary-interface.md
│   │   │   ├── handoff-protocol.md
│   │   │   ├── multi-db-interface.md
│   │   └── examples/
│   │       └── schema-template.sql
│   ├── notion-ao-bulletin/            # Infrastructure gate
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── lifecycle-patterns.md
│   ├── notion-ao-markdown-documentation/  # Markdown formatting (MIT)
│   │   ├── SKILL.md
│   │   ├── references/
│   │   │   ├── alerts-and-callouts.md
│   │   │   ├── collapsible-sections.md
│   │   │   ├── extended-syntax-github-flavored-markdown.md
│   │   │   ├── formula-and-code-blocks.md
│   │   │   ├── links-and-images.md
│   │   │   ├── lists.md
│   │   │   ├── mermaid-diagrams.md
│   │   │   └── text-formatting.md
│   │   └── templates/
│   │       └── doc-template.md
│   ├── notion-ao-project-context/     # Project context template
│   │   └── SKILL.md
│   ├── notion-ao-research-methodology/ # Research methodology + citation
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── citation-protocol.md
│   │       └── two-zone-model.md
│   └── notion-ao-writing-conventions/  # Writing style conventions
│       └── SKILL.md
├── handbook/
│   ├── README.md
│   ├── en/                         # English handbook
│   └── ko/                         # 한국어 핸드북
├── README.md
└── LICENSE                         # CC BY-NC-SA 4.0
```

---

## Cowork Marketplace Setup

When uploading this plugin to a [Cowork](https://cowork.ai) marketplace, you need a `marketplace.json` placed **one directory above** the plugin folder. This file tells the marketplace what plugin it contains and where to find it.

Create `marketplace.json` at the same level as the `notion-ao-research/` directory:

```json
{
  "name": "my-marketplace",
  "version": "1.0.0",
  "description": "My Cowork plugin marketplace",
  "owner": { "name": "rooftop-Owl" },
  "plugins": [
    { "name": "notion-ao-research", "version": "1.3.0", "source": "./notion-ao-research" }
  ]
}
```

The `source` path must point to the directory that contains `.claude-plugin/plugin.json`.

---

## License

[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) — see [LICENSE](./LICENSE)

You may use, share, and adapt this work for **non-commercial purposes** with attribution. Derivatives must use the same license.

> `skills/notion-ao-markdown-documentation/` is third-party content under the [MIT License](https://opensource.org/licenses/MIT) (from [aj-geddes/useful-ai-prompts](https://github.com/aj-geddes/useful-ai-prompts)).
