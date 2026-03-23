# API Patterns

## Tool Reference

| Tool | Purpose |
|---|---|
| `notion-fetch` | Fetch page/database/data-source details by ID or URL. |
| `notion-create-pages` | Create one or more pages in a parent page/data source. |
| `notion-update-page` | Update page properties or content (`update_properties`, `update_content`, `replace_content`). |
| `notion-search` | Search within workspace or scoped data source using semantic query. |
| `notion-create-database` | Create new database with SQL DDL schema. |
| `notion-create-view` | Create table/board/calendar/etc. views with optional filter/sort DSL. |
| `notion-create-comment` | Add page-level or block-targeted comments/discussion replies. |
| `notion-move-pages` | Move pages/databases to a new parent page/data source/workspace. |

## notion-create-pages

Canonical call shape for row creation in a data source:

```yaml
notion-create-pages:
  parent:
    data_source_id: "<DATA_SOURCE_ID>"
  pages:
    - properties:
        <TITLE_PROPERTY>: "<TITLE_TEXT>"
        <SELECT_PROP>: "<SELECT_VALUE>"
        <MULTI_SELECT_PROP>: "[\"Value1\", \"Value2\"]"
        <NUMBER_PROP>: 42
        date:<DATE_PROP>:start: "2026-04-01"
        date:<DATE_PROP>:is_datetime: 0
```

## notion-search

Database-scoped search pattern:

```yaml
notion-search:
  query: ""
  data_source_url: "collection://<DATA_SOURCE_ID>"
  page_size: 50
```

Notes:
- Use `query: ""` to list all records in scoped context (subject to pagination).
- Use non-empty query for find-by-name before updates.

## notion-update-page

### Property updates

```yaml
notion-update-page:
  page_id: "<page-id>"
  command: "update_properties"
  properties:
    <STATUS_PROP>: "In Progress"
    <CHECKBOX_PROP>: "__YES__"
    <NUMBER_PROP>: 65
```

### Content updates (search-and-replace)

```yaml
notion-update-page:
  page_id: "<page-id>"
  command: "update_content"
  content_updates:
    - old_str: "Old section"
      new_str: "Updated section"
```

## Find-then-Update Pattern

1. Search for target page:

```yaml
notion-search:
  query: "<entity-name>"
  data_source_url: "collection://<DATA_SOURCE_ID>"
  page_size: 10
```

2. Extract `page_id` from result.
3. Update with `notion-update-page`:

```yaml
notion-update-page:
  page_id: "<found-page-id>"
  command: "update_properties"
  properties:
    <TARGET_PROP>: "<NEW_VALUE>"
```

## Property Format Reference

| Property Type | Correct Format | Common Mistake |
|---|---|---|
| multi_select | `"[\"Value1\", \"Value2\"]"` (JSON string) | `["Value1", "Value2"]` (native array — FAILS) |
| date | `date:<PROP>:start`, `date:<PROP>:is_datetime` expanded keys | Single `date` key |
| checkbox | `"__YES__"` or `"__NO__"` | `true`/`false` booleans |
| number | plain JavaScript number | string |
| title | plain string (MCP) | rich_text object |

## Anti-Patterns

1. Sending native arrays for multi_select values instead of JSON strings.
2. Writing date payloads with a single `date` key instead of expanded `date:<PROP>:...` keys.
3. Sending empty title values during create operations.
