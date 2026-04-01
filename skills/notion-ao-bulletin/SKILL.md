---
name: notion-ao-bulletin
description: >-
  This skill should be used when creating, fixing, refactoring, or auditing
  notion-ao-* skills or commands — NOT for ordinary content operations. Load when user
  mentions "notion skill maintenance", "open issue", "bulletin board", "notion infra",
  "skill refactor", "architecture toggle". Provides the infrastructure maintenance
  gate pattern, Bulletin Board DB lifecycle, and architecture documentation protocol.
license: CC-BY-NC-SA-4.0
metadata:
  author: https://github.com/rooftop-Owl
  version: "1.3.0"
  domain: productivity
  triggers: notion skill maintenance, open issue, bulletin board, notion infra, skill refactor, architecture toggle, infrastructure gate, close issue, log enhancement
  role: specialist
  scope: governance
  output-format: api-calls
  related-skills: notion-ao-workspace, notion-ao-ops
---

# Notion Bulletin

Infrastructure maintenance gate for the `notion-*` skill family. Use this skill to keep issue tracking, shipped enhancements, and architecture records synchronized in a Bulletin Board database during Notion infrastructure work.

---

## Scope

| Load ✅ | Don't load ❌ |
|---------|--------------|
| Creating/editing notion-* skill files | Adding a diary entry |
| Refactoring notion commands | Querying research databases |
| Fixing a DB schema drift | Designing a Notion page |
| Resolving a Bulletin Board open issue | Writing a research note |
| Changing skill family architecture | Normal content operations |

If the task is normal page content authoring or data entry, do not load this skill.

---

## Runtime Resolution

Resolve the Bulletin Board database at runtime rather than hardcoding identifiers.

1. Read the workspace Notion configuration source used by the project.
2. Find a database entry with `Type = Issue tracking` or a database named `Bulletin Board`.
3. Extract:
   - `data_source_id` for database operations.
   - Parent page ID for page-level architecture toggle updates.
4. Cache those values in working memory for the current run.

If no Bulletin Board database exists, stop infrastructure logging flow and guide the user to add one first.

Recommended user guidance when missing:
- Create a `Bulletin Board` database in the Notion workspace.
- Add status/type/severity/category/resolution fields.
- Place it under the infrastructure page used for `notion-*` skill governance.

---

## Gate Rule

**Before ending any Notion infrastructure work session, you MUST:**

1. **Check active items** — did your work resolve any open issue or backlog item? → Update Status to `Done`, fill Resolution + Date Closed
2. **Log what you shipped** — create a new DB entry: Type=Enhancement, Status=Done, fill Resolution with context
3. **Check for new issues** — did your work surface anything? → Create entry: Type=Issue or Backlog
4. **Update Architecture toggles** — if you changed the skill family structure, page hierarchy, tool stack, or DB disambiguation, update the relevant toggle on the Bulletin Board page

No infrastructure session is complete until this 4-step checklist is done.

---

## Architecture Toggles

Maintain these six canonical toggles on the Bulletin Board page:

1. **General vs Project-Specific Boundary** — design rule for separating reusable logic from project data.
2. **Database Disambiguation** — how to distinguish workspace-wide databases from project-local databases.
3. **Page Layering Model** — lab-facing pages vs internal workflow pages.
4. **Skill Family Map** — the `notion-*` skill tree and ownership boundaries.
5. **Tool Architecture — notion-ao-research module** — the 3-layer stack (Skills → MCP → API).
6. **Workspace Page Hierarchy** — authoritative full page tree.

When architecture changes, update the affected toggle text in the same session.

---

## Additional Resources

- `references/lifecycle-patterns.md` — DB schema, status lifecycle, views, API call examples
