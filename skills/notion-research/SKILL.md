---
name: notion-research
description: >-
  This skill should be used when the user wants to "add entry", "log work",
  "query schedule", "add milestone", "log experiment", "add paper", "mark complete",
  "what's on today", "show experiments", "update status", or any other natural language
  operation on research tracking databases in Notion. Provides NL→database routing,
  API patterns, and operation conventions for any research workspace.
license: CC-BY-NC-SA-4.0
metadata:
  author: https://github.com/rooftop-Owl
  version: "1.1.0"
  domain: productivity
  triggers: add entry, log work, query schedule, add milestone, log experiment, add paper, mark complete, what's on today, show experiments, update status, research diary, handoff, hub and spoke
  role: specialist
  scope: operations
  output-format: api-calls
  related-skills: notion-workspace, notion-bulletin
---

# Notion Research

## Purpose

Provide a natural-language interface for research-tracking databases through Notion MCP tools. Resolve operations at runtime from workspace configuration, classify user intent into reusable operation patterns, and dispatch to the correct reference guide for implementation details in any configured research workspace.

## Runtime Resolution

1. Read workspace configuration first.
2. Match the user request to a database pattern by schema characteristics and intent cues.
3. Extract runtime values from config: `data_source_id`, title property name, and allowed select/multi-select options.
4. Build API calls using those runtime values only.
5. If workspace configuration is missing, load the `notion-workspace` skill and establish config before executing ADD/QUERY/UPDATE operations.

## Database Operation Patterns

| Pattern | Characteristics | Route to |
|---|---|---|
| Time-series log | Date-indexed entries, category tags, effort/hours tracking | `diary-interface.md` |
| Status-tracked items | Lifecycle statuses, due dates, milestone/task-like | `multi-db-interface.md` |
| Experiment registry | Phase workflow (designed→running→complete), findings, blockers | `multi-db-interface.md` |
| Reference-reading catalog | Authors, DOI/URL, reading status, relevance | `multi-db-interface.md` |
| Manuscript stage tracker | Draft stage progression, deadlines, progress % | `multi-db-interface.md` |
| Note archive | Category-tagged, date-stamped, free-form text | `multi-db-interface.md` |

### Matching signals

- **Time-series log**: `add entry`, `log work`, `what's on today`, `this week`, `log hours`
- **Status-tracked items**: `add milestone`, `mark complete`, `upcoming`, `at risk`
- **Experiment registry**: `log experiment`, `set blocker`, `log findings`, `set phase`
- **Reference-reading catalog**: `add paper`, `what am I reading`, `add citation`
- **Manuscript stage tracker**: `add chapter`, `move to drafting`, `progress`, `deadline`
- **Note archive**: `add note`, `design decision`, `analysis memo`, `bug fix`

## Intent Dispatch

| User intent | Operation | Load reference |
|---|---|---|
| "add/log [activity] [date/time]", "what's on today/this week", "mark X as done" | Time-series ADD/QUERY/UPDATE | `diary-interface.md` |
| "add milestone", "mark complete", "what's at risk", "show upcoming" | Status-tracked ADD/QUERY/UPDATE | `multi-db-interface.md` |
| "log experiment", "set blocker", "log findings" | Experiment ADD/UPDATE | `multi-db-interface.md` |
| "add paper", "what am I reading" | Reading-catalog ADD/QUERY | `multi-db-interface.md` |
| "add chapter", "move to drafting", "chapter progress" | Manuscript ADD/UPDATE/QUERY | `multi-db-interface.md` |
| "add note", "design decision", "bug fix" | Note ADD | `multi-db-interface.md` |
| "link paper to project", "hub and spoke", "create project view" | Cross-DB relation | `cross-db-workflow.md` |
| "update handoff", session ending | State persistence | `handoff-protocol.md` |

## Shared Conventions

- **Title property**: always use `<TITLE_PROPERTY>` from workspace config; never assume a fixed property name.
- **Multi-select values**: pass JSON-serialized string format `"[\"Value1\", \"Value2\"]"`, not a native array.
- **Date properties**: use expanded fields `date:<PROP>:start` and `date:<PROP>:is_datetime`.
- **Default behavior**: do not request confirmation for simple creates; execute and report result.
- **Find-then-update**: search first with `notion-search` + `data_source_url=collection://<DATA_SOURCE_ID>`, then patch by `page_id` with `notion-update-page`.

## Fallback Routing

When intent does not map cleanly to a known pattern:

1. Read workspace configuration and enumerate available databases plus schema summaries.
2. Match the user's noun/verb semantics to the most likely database target.
3. Validate property names and allowed option values from that database schema.
4. Execute the standard ADD/QUERY/UPDATE flow with runtime-resolved identifiers.

## Additional Resources

- `references/diary-interface.md` — Time-series log ADD/QUERY/UPDATE
- `references/multi-db-interface.md` — Status-tracked, experiment, reading-catalog, manuscript, note patterns
- `references/cross-db-workflow.md` — Hub-and-spoke, relation linking, filtered views
- `references/handoff-protocol.md` — Session state persistence (CURRENT/NEXT/BLOCKERS)
- `references/api-patterns.md` — Shared MCP API call shapes
- `examples/schema-template.sql` — Blank schema templates for common patterns
