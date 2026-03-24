---
name: sync-context
description: Fetch the project hub page from Notion and present current priorities, constraints, decisions, and recent handoffs.
---

Fetch and summarize the current project context from Notion.

1. Read `NOTION_WORKSPACE.md` (or equivalent workspace config) to resolve the Project Hub page ID (`<PROJECT_HUB_PAGE_ID>`).
2. Fetch the Project Hub page:
   - `notion-fetch(id="<PROJECT_HUB_PAGE_ID>")`
3. Read that page content and extract these sections:
   - Active Decisions
   - Current Priorities
   - Constraints
4. Query recent handoffs from the projects database:
   - Include only projects where `Handoff Context` is non-empty
   - Sort by `last_edited_time` descending
   - Take the top 3 results
5. Present the result in this exact section order:
   - **Active Decisions**
   - **Current Priorities**
   - **Constraints**
   - **Latest Handoffs**

Formatting rules:
- For **Active Decisions**, if the section is missing or empty, output: `None recorded yet`
- For **Current Priorities** and **Constraints**, show the extracted section content from the Project Hub page
- For **Latest Handoffs**, list each of the 3 most recent projects as:
  - Project title
  - First line of `Handoff Context`
