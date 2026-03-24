---
name: notion-workspace
description: >-
  This skill should be used when the user asks to "set up Notion", "connect Notion MCP",
  "create a notion workspace config", "configure Notion databases", "design a database",
  "create a new schema", "help me set up a DB", or "getting started with Notion".
  Establishes MCP connectivity, creates the workspace registry file, and routes to
  the correct notion-ao-research skill.
license: CC-BY-NC-SA-4.0
metadata:
  author: https://github.com/rooftop-Owl
  version: "1.1.0"
  domain: productivity
  triggers: set up Notion, connect MCP, workspace config, design database, create schema, getting started, Notion setup, MCP configuration
  role: gateway
  scope: setup
  output-format: configuration
  related-skills: notion-research, notion-bulletin, markdown-documentation
---

# notion-workspace

Use this skill as the gateway to the notion-ao-research skill family. Establish connectivity once, register workspace metadata once, then let downstream skills run with stable identifiers and schema context.

## Purpose

Initialize a Notion-compatible environment for research operations across agent platforms.

This skill handles:
- MCP connection setup baseline
- Workspace config creation and validation
- Runtime placeholder resolution rules used by all sibling skills
- Skill dispatch to the right specialized workflow

This skill does not perform day-to-day database operations. After setup, route operational requests to the family skill designed for that intent.

## Quick Start

1. **Connect MCP**
   - Configure a Notion MCP server on your platform.
   - Verify authentication and tool visibility.

2. **Create workspace config**
   - Create `NOTION_WORKSPACE.md` in project root from the template in `examples/workspace-config.md`.
   - Populate database registry, schema snippets, and project page registry.

3. **Load research skills**
   - Use this skill for setup and registration only.
   - Route daily operations to `notion-research`, `notion-bulletin`, or `notion-page-designer`.

## Runtime Resolution

All skills in this family must resolve placeholders from the workspace config file at runtime.

Resolution protocol:
1. Locate project-root `NOTION_WORKSPACE.md`.
2. Read the **Database Registry** table.
3. Match the logical database name requested by task intent.
4. Extract fields from the matched row:
   - `<DATA_SOURCE_ID>` from the registry `data_source_id` column
   - `<TITLE_PROPERTY>` from the registry title-property column
5. For page-targeted operations, read the **Project Pages** table and resolve `<PAGE_ID>`.
6. Use resolved values in tool calls and property payloads.

If `NOTION_WORKSPACE.md` is missing, stale, or ambiguous, stop execution and request workspace-config refresh before continuing.

## Skill Family

| Skill | Trigger Phrases | What it does |
|---|---|---|
| notion-workspace | "set up Notion", "connect MCP", "workspace config" | Setup and registration (this skill) |
| notion-research | "add entry", "query milestones", "log experiment", "mark complete" | NL research operations |
| notion-bulletin | "notion infra", "skill maintenance", "open issue" | Infrastructure maintenance gate |
| notion-page-designer | "design a page", "audit layout", "fix formatting" | Page design and layout |

## Workspace Configuration

`NOTION_WORKSPACE.md` is the shared runtime contract between users and agents.

Why it exists:
- Avoid repeated discovery queries every session
- Prevent hardcoded identifiers in skills
- Keep schema assumptions explicit and auditable

How agents use it:
- Resolve placeholders before any create/query/update operation
- Validate title property and key properties before writing
- Detect schema drift when expected properties/options no longer match

Minimum requirement: maintain one canonical `NOTION_WORKSPACE.md` per project root and keep it current with Notion-side schema changes.

## Operating Guidance

- Prefer standard tool names in examples and workflows:
  - `notion-fetch`
  - `notion-create-pages`
  - `notion-update-page`
  - `notion-search`
  - `notion-create-database`
  - `notion-create-view`
- Keep this skill platform-neutral. Platform-specific automation belongs in `references/platform-integrations.md`.
- Never hardcode project UUIDs in skill logic. Resolve from config at runtime.

## Additional Resources

### Reference Files

- **`references/setup-guide.md`** — Multi-platform MCP setup, token creation, verification, and manual config-generation workflow.
- **`references/workspace-config-spec.md`** — Normative format spec for `NOTION_WORKSPACE.md`, required sections, field semantics, and maintenance protocol.
- **`references/platform-integrations.md`** — Optional platform enhancements and automation patterns.
- **`references/schema-design.md`** — Decision tree for helping users design new database schemas: master tables, input sections, property types, status lifecycles, and views.

### Examples

- **`examples/workspace-config.md`** — Copy-paste, self-documenting template for creating `NOTION_WORKSPACE.md` from scratch.
