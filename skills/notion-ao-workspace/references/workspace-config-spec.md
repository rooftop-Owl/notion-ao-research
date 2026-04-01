# Workspace Config Spec

This document defines the universal workspace config format for the notion-ao-research skill family.

## 1) File format and location

- Format: **Markdown**
- Conventional name: **`NOTION_WORKSPACE.md`**
- Location: **project root** (same root used by the executing agent session)

Agents in this skill family must treat this file as the runtime source of truth for Notion identifiers and schema assumptions.

## 2) Required sections

`NOTION_WORKSPACE.md` must contain the following sections.

### A. Database Registry (required)

A table with one row per operational database.

Required columns:
- `logical_name` — short stable alias used in prompts and routing logic
- `data_source_id` — identifier used to target Notion data source operations
- `title_property` — exact title property key for this database
- `key_properties` — comma-separated list of frequently used properties

Recommended extra columns:
- `status_property`
- `date_property`
- `notes`

### B. Database Schemas (required)

One subsection per database containing a compact DDL-style schema snippet.

Purpose:
- Make property names explicit
- Document select/multi-select option vocabularies
- Reduce runtime ambiguity for updates

Minimum schema content per database:
- Title property
- Status-like properties
- Date properties (with `date:<prop>:start` mapping where applicable)
- Any required fields for create flows

### C. Project Pages (required)

A table of page IDs used by skills for page-level fetch/update operations.

Required columns:
- `name`
- `page_id`
- `url` (or canonical reference)
- `purpose`

## 3) Field definitions

### `data_source_id`

The Notion data source identifier used for database-level operations.

- Used by search/query/create flows targeting a database
- Commonly represented as `collection://<data_source_id>` in some tools
- Must be stored as a plain UUID-like identifier in the registry table

### `title_property`

Exact property name for the database title column.

- Must match case and spacing exactly
- Must not be assumed globally across databases
- Must be read from registry before create/update operations

### Select and multi-select options

When documenting schema options:
- List the canonical values exactly as configured in Notion
- Keep naming stable to avoid routing mismatches
- For multi-select, list valid tags as an explicit vocabulary when possible

## 4) Placeholder conventions

Use placeholders in skill logic and documentation. Resolve from `NOTION_WORKSPACE.md` at runtime.

- `<DATA_SOURCE_ID>` — resolved from Database Registry `data_source_id`
- `<TITLE_PROPERTY>` — resolved from Database Registry `title_property`
- `<PAGE_ID>` — resolved from Project Pages table

Rules:
1. Never hardcode these values in skill behavior.
2. Resolve placeholders immediately before tool execution.
3. Fail fast if a placeholder cannot be resolved uniquely.

## 5) Maintenance protocol

### Refresh triggers (schema drift signals)

Refresh `NOTION_WORKSPACE.md` when any of the following occurs:
- Tool error indicates missing/renamed property
- A select/multi-select value was added, removed, or renamed
- A database title property changed
- A new operational database is introduced
- Core project page IDs changed

### Update procedure

1. Fetch latest database metadata and page metadata from Notion.
2. Update Database Registry first.
3. Update Database Schemas to match current properties/options.
4. Update Project Pages table.
5. Run a smoke test using resolved placeholders.
6. Commit updated `NOTION_WORKSPACE.md` with a clear change note.

### Versioning recommendation

Add a small metadata header at top of `NOTION_WORKSPACE.md`:
- generated/refreshed timestamp
- maintainer or source method
- optional revision note

## 6) Validation checklist

- [ ] File exists at project root as `NOTION_WORKSPACE.md`
- [ ] All required sections exist
- [ ] Every logical database has `data_source_id` and `title_property`
- [ ] Project Pages contains all page IDs required by active skills
- [ ] Schema snippets match live Notion properties/options
- [ ] Placeholder resolution succeeds for create/query/update flows
