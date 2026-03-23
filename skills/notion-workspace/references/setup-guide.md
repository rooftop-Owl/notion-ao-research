# Setup Guide

Use this guide to establish Notion MCP access and generate the project workspace config on any MCP-compatible agent platform.

**What is MCP?** Model Context Protocol is an open standard that lets AI agents call external tools (like the Notion API) through a unified interface. When connected, your agent gains tools like `notion-fetch`, `notion-create-pages`, etc. — no custom code required.

## 1) Prerequisites

### Required accounts
- A **Notion account** with permission to create integrations
- Access to the pages/databases your agent will read/write

### Required software
- **An MCP-compatible agent client** — for example:
  - [Claude Code](https://github.com/anthropics/claude-code) (OpenCode)
  - [Cursor](https://cursor.com)
  - [Windsurf](https://codeium.com/windsurf)
  - Any client that supports the [Model Context Protocol](https://modelcontextprotocol.io)

- **Node.js v18+** (needed for the generic stdio setup in Option C below)
  - Check if installed: `node --version`
  - If not installed: download from [nodejs.org](https://nodejs.org) or use a package manager:
    ```bash
    # macOS (Homebrew)
    brew install node

    # Ubuntu/Debian
    sudo apt install nodejs npm

    # Windows (winget)
    winget install OpenJS.NodeJS.LTS
    ```
  - Node.js includes `npm` (package manager) and `npx` (package runner). `npx` lets you run packages without installing them globally — it downloads, runs, and cleans up automatically.

- **Shell access** — Terminal (macOS/Linux) or PowerShell/Command Prompt (Windows)

## 2) Create and authorize a Notion integration

1. Go to [**notion.so/my-integrations**](https://www.notion.so/my-integrations) and click **New integration**.
2. Give it a name (e.g., "Research Agent") and select the workspace.
3. Under **Capabilities**, ensure "Read content", "Update content", and "Insert content" are checked.
4. Click **Submit** and copy the **Internal Integration Secret** (starts with `ntn_`).
5. Save the token as an environment variable:

   ```bash
   # macOS / Linux
   export NOTION_API_TOKEN="ntn_your_token_here"

   # Windows PowerShell
   $env:NOTION_API_TOKEN = "ntn_your_token_here"

   # Windows CMD
   set NOTION_API_TOKEN=ntn_your_token_here
   ```

   To make this permanent, add it to your shell profile (`~/.zshrc`, `~/.bashrc`) or system environment variables on Windows.

6. **Grant page access**: In Notion, open each page/database your agent needs → click **•••** (top right) → **Add connections** → select your integration.
7. Confirm the integration name appears in the sharing panel.

> **Important**: Without explicit page access, MCP calls return "Object not found" even when the token is valid. This is the #1 setup mistake.

## 3) Connect Notion MCP to your agent platform

Choose the option that matches your platform. All three produce the same result: your agent gets access to Notion's MCP tools.
### A. Claude Code (OpenCode MCP OAuth)

Use remote MCP OAuth with the official endpoint:

```text
https://mcp.notion.com/mcp
```

Steps:
1. Run the MCP auth command:
   ```bash
   opencode mcp auth notion
   ```
2. Follow the browser OAuth flow to authorize your Notion workspace.
3. Restart your agent session.
4. Verify tools are available by asking: "list my Notion tools" or checking the MCP tool list.

Expected tools include:
- `notion-fetch`
- `notion-create-pages`
- `notion-update-page`
- `notion-search`
- `notion-create-database`
- `notion-create-view`

### B. Cursor

Add Notion MCP to your workspace configuration file.

**File location**: `.cursor/mcp.json` in your project root (create the directory if it doesn't exist):

```bash
mkdir -p .cursor
```

**File content**:

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

After saving, Cursor will prompt for OAuth authentication. Complete it, then restart the workspace.

### C. Generic stdio (any MCP client)

Use this if your client doesn't support remote OAuth. This runs the Notion MCP server locally as a subprocess.

**Requires**: Node.js v18+ (see Prerequisites above for installation).

Add to your client's MCP configuration file (check your client's docs for the exact file path):

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

**What this does**: `npx -y @notionhq/notion-mcp-server` downloads and runs the official Notion MCP server package. The `-y` flag auto-confirms the download. Your agent client manages the subprocess lifecycle — you don't need to run it manually.

**Make sure** `NOTION_API_TOKEN` is set in your environment before starting your agent (see step 2).

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
