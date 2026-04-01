# Platform Integrations

This document contains optional platform-specific enhancements for the `notion-ao-workspace` setup.

Core setup remains portable; use this file only when platform features can reduce manual maintenance.

## 1) astraeus integration (optional)

Use this section only when the runtime includes astraeus commands/hooks.

### Workspace config lifecycle

- `NOTION_WORKSPACE.md` can be auto-generated and refreshed by platform workflow (`/notion-sync`).
- Session hooks can consume the workspace file to avoid repeated discovery calls.
- Module packaging can distribute this skill family with shared references and templates.

### Suggested pattern

1. Run setup once to establish Notion access.
2. Generate `NOTION_WORKSPACE.md` through platform sync command.
3. Let hooks consume the file during session start/end.
4. Re-run sync after schema changes.

### Caution

- Do not assume astraeus is present in every environment.
- Keep skill logic independent from astraeus-only commands.

## 2) Cursor and Windsurf integration

Both platforms generally rely on workspace-level MCP config.

### Config location

- Project-level `mcp.json` (or platform-equivalent MCP settings file)

### Example shape

```json
{
  "mcpServers": {
    "notion": {
      "type": "sse",
      "url": "https://mcp.notion.com/mcp"
    }
  }
}
```

### Operational guidance

- Authenticate through platform MCP OAuth prompt.
- Restart workspace/session after config updates.
- Keep `NOTION_WORKSPACE.md` under source control for team consistency.

## 3) Generic MCP clients

For generic clients that support stdio or custom server execution:

### Env-var-first pattern

1. Export token:

```bash
export NOTION_API_TOKEN="<your-integration-token>"
```

2. Bind token into MCP server env.
3. Verify tools (`notion-fetch`, `notion-search`, `notion-create-pages`, `notion-update-page`).

### Maintenance model

- Maintain `NOTION_WORKSPACE.md` manually.
- Refresh on schema drift and page-registry changes.
- Use the example template from `examples/workspace-config.md`.

## 4) Integration decision matrix

| Platform style | Config method | Auth mode | Workspace config maintenance |
|---|---|---|---|
| astraeus | command + hooks | platform-managed/OAuth | auto-refresh possible |
| Cursor/Windsurf | `mcp.json` | OAuth prompt | manual or scripted |
| Generic MCP client | stdio/env config | token env var | manual |

## 5) Interop rules

- Keep placeholder resolution identical across platforms.
- Keep runtime contract fixed at `NOTION_WORKSPACE.md`.
- Keep Notion tool naming consistent in prompts and docs.
