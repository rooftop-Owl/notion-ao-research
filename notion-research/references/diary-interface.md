# Diary Interface

## Intent: ADD Entry

Map natural-language signals to properties in the time-series log database.

| Signal | Property | Mapping Rule |
|---|---|---|
| Event/activity phrase | `<TITLE_PROPERTY>` | Use the activity name directly (for example: `Lab meeting`, `Analysis session`, `Reading block`). |
| Date/time mention | `<DATE_PROP>` | Parse to ISO-8601. Set `date:<DATE_PROP>:is_datetime` to `1` when time is present, otherwise `0`. |
| Work-type keywords | `<CATEGORY_PROP>` | Use category keyword map below. |
| Project mention | `<PROJECT_PROP>` | Match against project select options from workspace configuration. |
| Effort mention (`3 hours`, `half day`) | `<HOURS_PROP>` | Convert to number (`3`, `4`, etc.). |
| Status cues | `<STATUS_PROP>` | Default to the first "not started"-equivalent status option from workspace config unless user explicitly indicates progress/completion. |

Category keyword map:

| Keywords in user text | Category value |
|---|---|
| meeting, seminar | `Meeting` |
| code, implement | `Coding` |
| read, paper, literature | `Reading` |
| write, draft | `Writing` |
| run, test, experiment | `Experiment` |
| analyze, plot, data | `Analysis` |
| review, check | `Review` |

Notes:
- Project options are runtime-resolved from workspace config (no hardcoded values).
- Status default should use the workspace's first pre-start lifecycle state.

## Intent: QUERY Schedule

Use `notion-search` with `data_source_url="collection://<DATA_SOURCE_ID>"`.

1. Today
   - Signal: "what's on today", "today's schedule"
   - Pattern: query scoped to entries where `<DATE_PROP>` falls on today.

2. This week
   - Signal: "this week", "what's coming up"
   - Pattern: query scoped to entries where `<DATE_PROP>` is in current week.

3. By category
   - Signal: "show meetings", "show reading"
   - Pattern: query scoped to entries where `<CATEGORY_PROP>` contains requested category.

4. By project
   - Signal: "show project tasks"
   - Pattern: query scoped to entries where `<PROJECT_PROP>` equals requested project.

## Intent: UPDATE Entry

Use `notion-update-page` after identifying target entry page.

1. Mark done
   - Signal: "mark X as done"
   - Update: `<STATUS_PROP>` → done terminal state.

2. Log hours
   - Signal: "log 3 hours on X"
   - Update: `<HOURS_PROP>` → numeric value.

3. Add reflection
   - Signal: "add reflection: ..."
   - Update: reflection text property with provided content.

## API Call Patterns

### Create entry

```yaml
notion-create-pages:
  parent:
    data_source_id: "<DATA_SOURCE_ID>"
  pages:
    - properties:
        <TITLE_PROPERTY>: "Lab Meeting"
        date:<DATE_PROP>:start: "2026-04-03T13:30"
        date:<DATE_PROP>:is_datetime: 1
        <CATEGORY_PROP>: "[\"Meeting\"]"
        <PROJECT_PROP>: "<PROJECT_OPTION>"
        <HOURS_PROP>: 1.5
        <STATUS_PROP>: "<DEFAULT_STATUS>"
```

### Query entries (today)

```yaml
notion-search:
  query: ""
  data_source_url: "collection://<DATA_SOURCE_ID>"
  page_size: 20
```

### Update entry

```yaml
notion-update-page:
  page_id: "<entry-page-id>"
  command: "update_properties"
  properties:
    <STATUS_PROP>: "Done"
    <HOURS_PROP>: 3
```

## Conventions

- Title must be activity name, not a date string.
- Multi-select values must be JSON array strings (for example: `"[\"Meeting\",\"Coding\"]"`).
- Use timezone from workspace configuration when parsing ambiguous local times.
- For simple add operations, execute directly without a confirmation round-trip.
- Treat recurring activities as separate individual entries; create each instance explicitly.
