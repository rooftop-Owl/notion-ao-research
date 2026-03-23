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

> **🤖 Agent behavior**: Steps 1-4 and 6 require browser actions. The agent should walk the user through each step with clear instructions, wait for confirmation, then proceed.

### Step 2a — Create the integration

Present this to the user:

```
I need you to create a Notion integration so I can access your workspace.

1. Open this link in your browser:
   👉 https://www.notion.so/my-integrations

2. Click "New integration"
3. Name it (e.g., "Research Agent")
4. Under Capabilities, make sure these are checked:
   ✅ Read content
   ✅ Update content
   ✅ Insert content
5. Click Submit
6. Copy the token that appears (it starts with "ntn_")

Paste the token here when you're done.
```

**After the user provides the token** — the agent should:
1. Verify format: token starts with `ntn_` and is 50+ characters
2. Set the environment variable:
   ```bash
   export NOTION_API_TOKEN="<user-provided-token>"
   ```
3. On Windows, use:
   ```powershell
   $env:NOTION_API_TOKEN = "<user-provided-token>"
   ```
4. For persistence, write to the platform's config:
   - **Claude Code**: set via `opencode mcp` or `.env` file (NOT committed to git)
   - **Cursor**: inject into `.cursor/mcp.json` env block
   - **Other**: write to `.env` at project root, add `.env` to `.gitignore`

> ⚠️ NEVER commit tokens to git. NEVER echo tokens in output. If writing to a config file, verify `.gitignore` covers it first.

### Step 2b — Grant page access

Present this to the user:

```
Now I need access to your Notion pages. For each page or database you want me to work with:

1. Open the page in Notion
2. Click the ••• menu (top right)
3. Click "Add connections"
4. Search for and select your integration name (e.g., "Research Agent")

Which pages/databases did you share? (paste the URLs or names)
```

**After the user confirms** — the agent should:
1. Try `notion-search` with `query: ""` and `page_size: 1` to verify at least one result returns
2. If "Object not found" error → tell the user: "It looks like the integration doesn't have access yet. Can you double-check that you added the connection to the pages?"
3. If successful → proceed to section 3 (MCP connection)

> **Why this step exists**: Notion integrations start with ZERO access. Even with a valid token, every page/database must be explicitly shared with the integration. This is by design (security) but is the #1 cause of setup failures.

## 3) Connect Notion MCP to your agent platform

> **🤖 Agent-executable** — The agent can perform these steps directly. For Options A and B, OAuth requires the user to click "Authorize" in a browser window that opens automatically.

Ask the user which platform they're using, then follow the matching option:
### A. Claude Code (OpenCode MCP OAuth)

Use remote MCP OAuth with the official endpoint:

```text
https://mcp.notion.com/mcp
```

The agent should:
1. Run the MCP auth command:
   ```bash
   opencode mcp auth notion
   ```
2. Tell the user:
   ```
   A browser window should have opened. Please authorize the Notion connection
   and come back here when done.
   ```
3. After the user confirms, restart the session and verify tools are available.
4. Verify tools are available by asking: "list my Notion tools" or checking the MCP tool list.

Expected tools include:
- `notion-fetch`
- `notion-create-pages`
- `notion-update-page`
- `notion-search`
- `notion-create-database`
- `notion-create-view`

### B. Cursor

The agent should:
1. Create the config directory and file:
   ```bash
   mkdir -p .cursor
   ```
2. Write `.cursor/mcp.json`:
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
3. Tell the user:
   ```
   I've added the Notion MCP config. Please restart Cursor.
   When it reopens, you'll see an OAuth prompt — click "Authorize" to connect your Notion workspace.
   Let me know once that's done.
   ```
4. After the user confirms, verify tools are available.

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

> **🤖 Agent-executable** — The agent should run these checks automatically after setup.

Quick API check (agent can run this directly):

```bash
curl -s https://api.notion.com/v1/users/me \
  -H "Authorization: Bearer $NOTION_API_TOKEN" \
  -H "Notion-Version: 2022-06-28" | head -c 200
```

Then run one MCP tool probe:
- `notion-search` with query `""` and `page_size: 1` — should return at least one result
- OR `notion-fetch` against a known page URL/ID from the shared pages

**Success criteria**:
- curl returns JSON with user info (not an error)
- MCP tool returns page/database metadata (not "Object not found")
- If "Object not found": the user forgot to grant page access (step 2.6) — ask them to do it

## 5) Generate `NOTION_WORKSPACE.md`

> **🤖 Agent-executable** — The agent can generate this file entirely on its own once MCP is connected.

### Recommended flow (agent-driven)

1. Copy `examples/workspace-config.md` into project root as `NOTION_WORKSPACE.md`.
2. Use `notion-search` with `query: ""` to discover all accessible databases.
3. For each database:
   - Run `notion-fetch` on the database URL to get its schema.
   - Extract: `data_source_id`, title property name, key properties, select/multi-select options.
4. Fill the **Database Registry** table in `NOTION_WORKSPACE.md`.
5. Add DDL snippets for each database in **Database Schemas**.
6. Add key project pages in **Project Pages** with page IDs and purpose notes.
7. Save the file — the workspace is now configured for all notion-research skills.

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
