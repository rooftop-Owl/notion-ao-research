# Setup Guide

Use this guide to establish Notion MCP access and generate the project workspace config on any MCP-compatible agent platform.

## 1) Prerequisites

- A Notion account with permission to create integrations
- Access to the pages/databases your agent must read/write
- An MCP-capable client (Claude Code, Cursor, Windsurf, or another MCP runtime)
- Shell access for setting environment variables

## 2) Create and authorize a Notion integration

1. Open Notion integrations and create a new **internal integration**.
2. Copy the integration token.
3. Export the token for local runtime:

```bash
export NOTION_API_TOKEN="<your-integration-token>"
```

4. In Notion, open each target page/database and grant access to the integration.
5. Confirm the integration appears in page/database sharing settings.

Without explicit page access, MCP calls return permission errors even when the token is valid.

## 3) Platform setup options

### A. Claude Code (OpenCode MCP OAuth)

Use remote MCP OAuth with the official endpoint:

```text
https://mcp.notion.com/mcp
```

Typical flow:
1. Add the Notion MCP server in your client MCP settings.
2. Run client auth flow (for example: `opencode mcp auth notion`).
3. Re-open session and verify tools are listed.

Expected tools include:
- `notion-fetch`
- `notion-create-pages`
- `notion-update-page`
- `notion-search`
- `notion-create-database`
- `notion-create-view`

### B. Cursor (mcp.json)

Create or update workspace-level `mcp.json` with a Notion entry:

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

Then authenticate through Cursor's MCP auth prompt and restart the workspace.

### C. Generic stdio runtime

If your client does not support remote OAuth MCP, configure stdio with environment variable auth:

```json
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "@notionhq/notion-mcp-server"],
      "env": {
        "NOTION_API_TOKEN": "${NOTION_API_TOKEN}"
      }
    }
  }
}
```

Exact package or command name can vary by runtime distribution. Keep the `NOTION_API_TOKEN` binding and verify available tool names after startup.

## 4) Verify connectivity

Run an API-level check first:

```bash
curl https://api.notion.com/v1/users/me \
  -H "Authorization: Bearer $NOTION_API_TOKEN" \
  -H "Notion-Version: 2022-06-28"
```

Then run one MCP tool probe:
- `notion-search` with a small query, or
- `notion-fetch` against a known page URL/ID.

Success criteria:
- No auth errors
- No permission errors for intended workspace scope
- Tool response contains expected page/database metadata

## 5) Generate `NOTION_WORKSPACE.md`

### Manual generation (portable default)

1. Copy `examples/workspace-config.md` into project root as `NOTION_WORKSPACE.md`.
2. For each target database:
   - Use `notion-fetch` on database/data-source URL.
   - Capture `data_source_id`, title property name, key properties, select/multi-select options.
3. Fill the **Database Registry** section.
4. Add minimal DDL snippets for each database in **Database Schemas**.
5. Add key project pages in **Project Pages** with page IDs and purpose notes.
6. Save and commit the file to the project repository.

### Optional auto-generation

Some platforms provide helper commands to auto-build or refresh `NOTION_WORKSPACE.md`.
See `references/platform-integrations.md` for platform-specific automation.

## 6) Post-setup validation checklist

- [ ] Notion token exists in environment (`NOTION_API_TOKEN`)
- [ ] MCP server connected and authenticated
- [ ] Standard Notion tools available (`notion-fetch`, `notion-create-pages`, `notion-update-page`, `notion-search`)
- [ ] `NOTION_WORKSPACE.md` exists at project root
- [ ] Registry rows include accurate `data_source_id` and title property
- [ ] First create/query/update smoke test succeeds with resolved placeholders

## 7) Common failures and fixes

### "Unauthorized" or "Invalid token"
- Recreate token or re-authenticate MCP server.
- Confirm runtime actually exports `NOTION_API_TOKEN`.

### "Object not found" / permission denied
- Grant integration access to the specific page/database.
- Re-run `notion-fetch` after sharing update.

### Tools missing from MCP client
- Restart client session after MCP config change.
- Validate MCP config syntax and endpoint.

### Placeholder resolution fails at runtime
- Confirm `NOTION_WORKSPACE.md` is in project root.
- Confirm logical database names match registry entries exactly.
