# Multi-Database Interface

## Status-Tracked Items

Use this pattern for milestone/task-style databases with lifecycle state, due date, and category.

### ADD

NL signals:
- "add milestone", "add task", "create checkpoint"
- "due next week", "due on <date>"

Property mapping:

| Signal | Property Placeholder | Mapping |
|---|---|---|
| Item name | `<TITLE_PROPERTY>` | Use concise action-oriented title. |
| Lifecycle status cue | `<STATUS_PROP>` | One of: `Upcoming`, `In Progress`, `At Risk`, `Complete`, `Deferred`. Default: `Upcoming`. |
| Category cue | `<CATEGORY_PROP>` | Map to configured category option from workspace schema. |
| Due date phrase | `<DUE_DATE_PROP>` | Set `date:<DUE_DATE_PROP>:start` + `date:<DUE_DATE_PROP>:is_datetime`. |

API example:

```yaml
notion-create-pages:
  parent:
    data_source_id: "<DATA_SOURCE_ID>"
  pages:
    - properties:
        <TITLE_PROPERTY>: "Checkpoint: baseline validation"
        <STATUS_PROP>: "Upcoming"
        <CATEGORY_PROP>: "<CATEGORY_VALUE>"
        date:<DUE_DATE_PROP>:start: "2026-04-15"
        date:<DUE_DATE_PROP>:is_datetime: 0
```

### UPDATE

NL signals:
- "mark as complete"
- "set to in progress"
- "flag this at risk"

Use `notion-update-page` to change `<STATUS_PROP>`, date, or category on the target page.

### QUERY

NL signals:
- "what is in progress"
- "show upcoming"
- "what is at risk"

Use `notion-search` scoped to `collection://<DATA_SOURCE_ID>`, then apply status/date criteria.

## Experiment Registry

Use this pattern for run-tracking records with phase workflow, findings, and blockers.

### ADD

NL signals:
- "log experiment"
- "create test run"
- "new benchmark run"

Property mapping:

| Signal | Property Placeholder | Mapping |
|---|---|---|
| Experiment name | `<TITLE_PROPERTY>` | Use short run identifier plus purpose. |
| Workflow phase/status | `<STATUS_PROP>` | One of: `Designed`, `Setup`, `Running`, `Analyzing`, `Complete`, `Blocked`. Default: `Designed`. |
| Optional phase detail | `<PHASE_PROP>` | Map to configured phase option if present. |
| Initial notes | `<DESCRIPTION_PROP>` | Store objective/protocol summary. |

API example:

```yaml
notion-create-pages:
  parent:
    data_source_id: "<DATA_SOURCE_ID>"
  pages:
    - properties:
        <TITLE_PROPERTY>: "Ablation run — localization threshold"
        <STATUS_PROP>: "Designed"
        <PHASE_PROP>: "Protocol"
        <DESCRIPTION_PROP>: "Compare two parameter settings on same dataset."
```

### UPDATE

NL signals:
- "move to running/analyzing/complete"
- "set blocker: ..."
- "log findings: ..."

Use `notion-update-page`:
- `<STATUS_PROP>` for lifecycle transition.
- `<BLOCKER_PROP>` for blocker text.
- `<FINDINGS_PROP>` for outcomes/observations.

### QUERY

NL signals:
- "what experiments are running"
- "show blocked experiments"

Use `notion-search` + status filtering for active or blocked runs.

## Literature Catalog

Use this pattern for reading/citation tracking.

### ADD

NL signals:
- "add paper"
- "add reference"
- "track this article"

Title convention:
- `<TITLE_PROPERTY>` should follow: `Author et al. (Year) — Title`

Statuses:
- `To Read` | `Reading` | `Done` | `Key Reference`

Property mapping:

| Signal | Property Placeholder | Mapping |
|---|---|---|
| Author/year/title | `<TITLE_PROPERTY>` | Compose title using required convention. |
| Author list | `<AUTHORS_PROP>` | Plain text authors string. |
| Year | `<YEAR_PROP>` | Number value. |
| Item type | `<TYPE_PROP>` | Configured option (paper/book/report/etc.). |
| DOI or link | `<DOI_PROP>` | DOI or canonical URL string. |
| Relevance | `<RELEVANCE_PROP>` | Configured relevance option. |
| Reading status | `<STATUS_PROP>` | Default `To Read` unless explicit cue. |

API example:

```yaml
notion-create-pages:
  parent:
    data_source_id: "<DATA_SOURCE_ID>"
  pages:
    - properties:
        <TITLE_PROPERTY>: "Kim et al. (2025) — Data Assimilation Benchmark"
        <AUTHORS_PROP>: "Kim et al."
        <YEAR_PROP>: 2025
        <TYPE_PROP>: "Paper"
        <STATUS_PROP>: "To Read"
        <DOI_PROP>: "10.1000/example-doi"
        <RELEVANCE_PROP>: "Core"
```

### UPDATE

NL signals:
- "mark as reading/done"
- "set as key reference"

Use `notion-update-page` to patch `<STATUS_PROP>` and optional note fields.

### QUERY

NL signals:
- "what am I reading"
- "show key references"

Use `notion-search` scoped to catalog and filter by `<STATUS_PROP>`.

## Writing Pipeline

Use this pattern for manuscript/chapter workflow tracking.

### ADD

NL signals:
- "add chapter"
- "create manuscript item"
- "start draft"

Stages:
- `Outline` | `Drafting` | `Review` | `Submitted` | `Accepted` | `Revision`

Fields:
- `<TYPE_PROP>`
- `<VENUE_PROP>`
- `<DEADLINE_PROP>`
- `<PROGRESS_PROP>`

API example:

```yaml
notion-create-pages:
  parent:
    data_source_id: "<DATA_SOURCE_ID>"
  pages:
    - properties:
        <TITLE_PROPERTY>: "Chapter 2 — Methods"
        <STATUS_PROP>: "Outline"
        <TYPE_PROP>: "Thesis Chapter"
        <VENUE_PROP>: "<TARGET_VENUE>"
        date:<DEADLINE_PROP>:start: "2026-06-30"
        date:<DEADLINE_PROP>:is_datetime: 0
        <PROGRESS_PROP>: 10
```

### UPDATE

NL signals:
- "move to drafting/review/submitted"
- "update progress to 60%"
- "change deadline"

Use `notion-update-page` to patch stage, progress number, deadline, and venue/type if needed.

### QUERY

NL signals:
- "chapter progress"
- "what is in review"
- "what is due soon"

Use `notion-search` with stage and deadline filters.

## Note Archive

Use this pattern for lightweight contextual notes and decisions.

### ADD

NL signals:
- "add note"
- "record decision"
- "log bug fix"

Category inference:

| Keywords in user text | Category value |
|---|---|
| bug, fix | `Bug Fix` |
| decision, why | `Design Decision` |
| physics, theory | `Physics` |
| config, parameter | `Configuration` |
| result, finding | `Experiment Result` |

Tags:
- Serialize as JSON array string (for example: `"[\"insight\",\"todo\"]"`).

API example:

```yaml
notion-create-pages:
  parent:
    data_source_id: "<DATA_SOURCE_ID>"
  pages:
    - properties:
        <TITLE_PROPERTY>: "Decision: adjust localization radius"
        <CATEGORY_PROP>: "Design Decision"
        date:<DATE_PROP>:start: "2026-03-23"
        date:<DATE_PROP>:is_datetime: 0
        <TAGS_PROP>: "[\"decision\",\"method\"]"
```
