# Bulletin Board Lifecycle Patterns

Reference for maintaining an infrastructure-focused Bulletin Board database used by `notion-*` skill and command maintenance.

---

## Database Schema

```sql
CREATE TABLE "Bulletin Board" (
  "<TITLE_PROPERTY>"  TITLE,
  "Status"            SELECT,    -- Open | In Progress | Mitigated | Known Limit | Done
  "Type"              SELECT,    -- Issue | Backlog | Enhancement
  "Severity"          SELECT,    -- 🔴 High | 🟡 Medium | 🟢 Low
  "Category"          SELECT,    -- Bug | Feature | Refactor | Convention
  "Related"           RICH_TEXT, -- Cross-reference e.g. "#2" or "—"
  "Resolution"        RICH_TEXT, -- How resolved (filled on close)
  "Date Closed"       DATE,
  "Notes"             RICH_TEXT
)
```

---

## Status Lifecycle

```text
Problem found         → Type=Issue, Status=Open
  Fixable now?        → fix → Status=Done, fill Resolution + Date Closed
  Not fixable yet?    → stays Open; optionally create Type=Backlog for the fix
  Platform limit?     → Status=Known Limit (permanent)
Enhancement idea      → Type=Enhancement, Status=Open
Backlog item picked   → Status=Done, fill Resolution + Date Closed
```

---

## Standard Views

1. **INPUT**: create form
2. **Active Issues**: Status ≠ Done, Type = Issue
3. **Known Limits**: Status = Known Limit
4. **Backlog**: Type = Backlog or Enhancement, Status ≠ Done
5. **Recently Completed**: Status = Done, sorted by Date Closed desc

---

## API Call Examples

### 1) Close an issue (`notion-update-page`)

```json
{
  "page_id": "<PAGE_ID>",
  "command": "update_properties",
  "properties": {
    "Status": "Done",
    "Resolution": "Fixed schema mismatch in maintenance workflow",
    "date:Date Closed:start": "2026-03-23",
    "date:Date Closed:is_datetime": 0
  }
}
```

### 2) Log a completed item (`notion-create-pages`)

```json
{
  "parent": { "data_source_id": "<DATA_SOURCE_ID>" },
  "pages": [
    {
      "properties": {
        "<TITLE_PROPERTY>": "Shipped bulletin lifecycle guard updates",
        "Status": "Done",
        "Type": "Enhancement",
        "Severity": "🟢 Low",
        "Category": "Convention",
        "Resolution": "Added session-end checklist enforcement",
        "date:Date Closed:start": "2026-03-23",
        "date:Date Closed:is_datetime": 0
      }
    }
  ]
}
```

### 3) Search for open items (`notion-search`)

```json
{
  "query": "",
  "data_source_url": "collection://<DATA_SOURCE_ID>",
  "page_size": 100
}
```

Use follow-up filtering logic to keep items where `Status != Done`.
