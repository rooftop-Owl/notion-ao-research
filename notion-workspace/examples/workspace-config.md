# NOTION_WORKSPACE.md
<!-- Project workspace registry for Notion operations. -->
<!-- Copy this file to your project root and replace all placeholders. -->
<!-- Keep this file in version control so every agent/session uses the same registry. -->

---

## Metadata

<!-- Optional but recommended: update when refreshing schemas or IDs. -->
- Refreshed At: `<YYYY-MM-DDTHH:mm:ssZ>`
- Maintainer: `<TEAM_OR_PERSON_OR_AUTOMATION>`
- Notes: `<SHORT_CHANGE_NOTE>`

---

## Database Registry

<!-- Required section. One row per operational database. -->
<!-- logical_name: stable alias used by skills (do not rename casually). -->
<!-- data_source_id: the ID used for database-level operations. -->
<!-- title_property: exact title property key from Notion schema. -->
<!-- key_properties: frequently used properties for create/update/query flows. -->

| logical_name | data_source_id | title_property | key_properties | status_property | date_property | notes |
|---|---|---|---|---|---|---|
| `<MILESTONES_DB_ALIAS>` | `<YOUR_DATA_SOURCE_ID>` | `<YOUR_TITLE_PROPERTY>` | `<PROP_A>, <PROP_B>, <PROP_C>` | `<STATUS_PROPERTY>` | `<DATE_PROPERTY>` | `<OPTIONAL_NOTES>` |
| `<EXPERIMENTS_DB_ALIAS>` | `<YOUR_DATA_SOURCE_ID>` | `<YOUR_TITLE_PROPERTY>` | `<PROP_A>, <PROP_B>, <PROP_C>` | `<STATUS_PROPERTY>` | `<DATE_PROPERTY>` | `<OPTIONAL_NOTES>` |
| `<NOTES_DB_ALIAS>` | `<YOUR_DATA_SOURCE_ID>` | `<YOUR_TITLE_PROPERTY>` | `<PROP_A>, <PROP_B>, <PROP_C>` | `<STATUS_PROPERTY_OR_NA>` | `<DATE_PROPERTY_OR_NA>` | `<OPTIONAL_NOTES>` |
| `<LITERATURE_DB_ALIAS>` | `<YOUR_DATA_SOURCE_ID>` | `<YOUR_TITLE_PROPERTY>` | `<PROP_A>, <PROP_B>, <PROP_C>` | `<STATUS_PROPERTY>` | `<DATE_PROPERTY_OR_NA>` | `<OPTIONAL_NOTES>` |
| `<WRITING_DB_ALIAS>` | `<YOUR_DATA_SOURCE_ID>` | `<YOUR_TITLE_PROPERTY>` | `<PROP_A>, <PROP_B>, <PROP_C>` | `<STATUS_PROPERTY>` | `<DATE_PROPERTY>` | `<OPTIONAL_NOTES>` |

---

## Database Schemas

<!-- Required section. Include one subsection per database listed above. -->
<!-- Keep property names exact. Include status/date/select vocab where relevant. -->

### `<MILESTONES_DB_ALIAS>`

```sql
CREATE TABLE IF NOT EXISTS "collection://<YOUR_DATA_SOURCE_ID>" (
  "<YOUR_TITLE_PROPERTY>" TEXT,          -- title (required)
  "<STATUS_PROPERTY>" TEXT,              -- e.g. Planned, In Progress, Complete
  "date:<DATE_PROPERTY>:start" TEXT,     -- YYYY-MM-DD or datetime
  "date:<DATE_PROPERTY>:is_datetime" INTEGER,
  "<NOTES_PROPERTY>" TEXT
);
```

### `<EXPERIMENTS_DB_ALIAS>`

```sql
CREATE TABLE IF NOT EXISTS "collection://<YOUR_DATA_SOURCE_ID>" (
  "<YOUR_TITLE_PROPERTY>" TEXT,
  "<STATUS_PROPERTY>" TEXT,
  "<PHASE_PROPERTY>" TEXT,
  "<FINDINGS_PROPERTY>" TEXT,
  "<BLOCKER_PROPERTY>" TEXT
);
```

### `<NOTES_DB_ALIAS>`

```sql
CREATE TABLE IF NOT EXISTS "collection://<YOUR_DATA_SOURCE_ID>" (
  "<YOUR_TITLE_PROPERTY>" TEXT,
  "<CATEGORY_PROPERTY>" TEXT,
  "date:<DATE_PROPERTY>:start" TEXT,
  "date:<DATE_PROPERTY>:is_datetime" INTEGER,
  "<TAGS_PROPERTY>" TEXT                 -- JSON string for multi-select
);
```

### `<LITERATURE_DB_ALIAS>`

```sql
CREATE TABLE IF NOT EXISTS "collection://<YOUR_DATA_SOURCE_ID>" (
  "<YOUR_TITLE_PROPERTY>" TEXT,
  "<AUTHORS_PROPERTY>" TEXT,
  "<YEAR_PROPERTY>" FLOAT,
  "<TYPE_PROPERTY>" TEXT,
  "<STATUS_PROPERTY>" TEXT,
  "<DOI_PROPERTY>" TEXT
);
```

### `<WRITING_DB_ALIAS>`

```sql
CREATE TABLE IF NOT EXISTS "collection://<YOUR_DATA_SOURCE_ID>" (
  "<YOUR_TITLE_PROPERTY>" TEXT,
  "<STATUS_PROPERTY>" TEXT,
  "<TYPE_PROPERTY>" TEXT,
  "date:<DEADLINE_PROPERTY>:start" TEXT,
  "date:<DEADLINE_PROPERTY>:is_datetime" INTEGER
);
```

---

## Project Pages

<!-- Required section. Include all page-level targets used by skills. -->
<!-- page_id values are used to resolve <PAGE_ID> placeholders at runtime. -->

| name | page_id | url | purpose | owner |
|---|---|---|---|---|
| `<PROJECT_DASHBOARD_PAGE>` | `<YOUR_PAGE_ID>` | `<YOUR_NOTION_URL>` | `<MAIN_ENTRY_PAGE_PURPOSE>` | `<OWNER_OR_TEAM>` |
| `<PROJECT_ROW_PAGE>` | `<YOUR_PAGE_ID>` | `<YOUR_NOTION_URL>` | `<PROJECT_STATUS_AND_HANDOFF_PURPOSE>` | `<OWNER_OR_TEAM>` |
| `<REFERENCE_PAGE>` | `<YOUR_PAGE_ID>` | `<YOUR_NOTION_URL>` | `<SUPPORTING_CONTEXT_PURPOSE>` | `<OWNER_OR_TEAM>` |

---

## Runtime Resolution Notes

<!-- Optional but useful: keep a short mapping reminder for maintainers. -->

- `<DATA_SOURCE_ID>` resolves from **Database Registry.data_source_id**
- `<TITLE_PROPERTY>` resolves from **Database Registry.title_property**
- `<PAGE_ID>` resolves from **Project Pages.page_id**

If any placeholder cannot be resolved uniquely, refresh this file before running create/update operations.

---

## Maintenance Log

<!-- Append one line per refresh to preserve change history. -->
<!-- Example: 2026-03-20 | Updated milestones status options after schema change | by @agent -->

- `<YYYY-MM-DD> | <WHAT_CHANGED> | by <WHO>`
