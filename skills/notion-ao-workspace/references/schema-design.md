# Schema Design Reference

## When to Load
Load this reference when the user asks to:
- "design a database"
- "create new schema"
- "help me set up a DB"
- "what properties should I use"
- "how should I structure this"

## Schema Design Steps

### Step 1 — Identify operation pattern
Classify the database by row meaning and lifecycle behavior.

| User Signal | Pattern | Row Represents | Default Lifecycle |
|---|---|---|---|
| Date-first logging, recurring entries | time-series log | one dated event/activity | queued → done |
| Work items with progress tracking | status-tracked items | one task/milestone/item | entry → in-progress → terminal |
| Trial/run/protocol tracking | experiment registry | one experiment or run | designed → running → analyzed/complete |
| Reading/reference management | literature catalog | one source/document | to-read → reading → done |
| Draft/review/submission process | writing pipeline | one writing artifact | idea → drafting → review → submitted |
| Free-form notes + retrieval | note archive | one note record | created → categorized → archived |

Decision branch:
- IF one pattern matches clearly, THEN proceed to Step 2.
- IF multiple patterns match, THEN pick the dominant row meaning (single row identity wins).
- IF no pattern matches, THEN ask:
  - "What will each row represent?"
  - "What states will items go through?"

### Step 2 — Select base schema
Use template dispatch from `examples/schema-template.sql`.

| Pattern | Template to Load | Adaptation Rules |
|---|---|---|
| time-series log | Time-Series Log | Rename title/date/category fields to domain terms; keep one primary date property. |
| status-tracked items | Status-Tracked Items | Keep Status + Due Date core; rename Category/Notes to domain vocabulary. |
| experiment registry | Experiment Registry | Keep Status + Phase pair; keep findings/blocker capture fields. |
| literature catalog | Literature Catalog | Keep citation metadata + reading status + relevance marker. |
| writing pipeline | Status-Tracked Items (writing variant) | Rename Status options to writing stages; keep deadline/submission markers. |
| note archive | Note Archive | Keep category + date + tags minimal set. |

Decision branch:
- IF user already has required property names, THEN map template columns to exact names.
- IF user has no naming constraints, THEN keep template-friendly neutral names.
- IF lifecycle absent, THEN keep minimal schema and defer status design to Step 4 fallback.

### Step 3 — Design Input Section
Pick one input method based on required field count and validation strictness.

| Condition | Method | Filter Logic | Outcome |
|---|---|---|---|
| ≤3 required fields | Simple | `<COMPLETE_FIELD> = unchecked` | Fast entry, minimal friction. |
| 4+ required fields | OR-required | `field1 empty OR field2 empty OR ... OR complete unchecked` | Row remains visible until all required fields are filled. |
| Repetitive defaults on new rows | Auto-fill | Same filter as Simple/OR + defaults | Reduces repeated typing and missing defaults. |

Auto-fill dispatch:
- IF date defaults to current day, THEN set creation rule `date=today`.
- IF one category is dominant, THEN pre-populate default category.
- IF new rows always belong to one hub entity, THEN pre-populate default relation.

### Step 4 — Design status lifecycle
Define status state machine only when item progression exists.

Required state buckets:
1. Entry state (initial)
2. In-progress states (1–3)
3. Terminal state (done/complete/archived)
4. Exception states (blocked/deferred/cancelled)

Lifecycle dispatch:
- IF users describe stage transitions, THEN implement `Status` as Select with ordered options.
- IF users only need finished/not finished, THEN skip lifecycle and use `Complete` checkbox.
- IF exception handling matters, THEN include exception states from day one.
- IF exception handling does not matter, THEN omit exception states to reduce complexity.

### Step 5 — Identify relations
Trigger relation design only when cross-database references exist.

Relation decision tree:
- IF user mentions multiple databases, projects, owners, or shared categories, THEN create relation model.
- IF a central anchor exists (project/person/category), THEN designate it as hub entity.
- THEN add:
  - Relation property from spoke DB to hub DB.
  - Rollup on hub DB for aggregate counts/percent complete.

Dispatch table:

| Multi-DB Signal | Hub Candidate | Required Property Additions |
|---|---|---|
| "linked to project" | project | Relation: Item→Project, Rollup: project item count |
| "owned by person/team" | person/team | Relation: Item→Owner, Rollup: open items per owner |
| "belongs to category catalog" | category | Relation: Item→Category, Rollup: items per category |

### Step 6 — Design views
Create a baseline view set for every database.

| View | Filter | Sort | Layout |
|---|---|---|---|
| Input | `<COMPLETE_FIELD> = unchecked` | newest first | table |
| Active | `Status ≠ terminal` | due date asc or priority desc | table/board |
| Complete | `Status = terminal` | completion date desc | table/list |
| Calendar (date-indexed) | date present | date asc | calendar |
| Grouped (categorized) | category/project present | group key asc | board/table-grouped |

View dispatch:
- IF database is date-indexed, THEN include Calendar view.
- IF database has category/project property, THEN include Grouped view.
- IF no status field exists, THEN replace Status filters with Complete checkbox filters.

## Property Type Selection

| Need | Use | NOT |
|------|-----|-----|
| One value from fixed list | Select | Multi-select |
| Multiple values from fixed list | Multi-select | Comma-separated rich_text |
| Link to another DB | Relation | Free-text name reference |
| Computed value | Formula | Manual entry that could be derived |
| Aggregate from related DB | Rollup | Manual count/sum |
| True/false toggle | Checkbox | Select with Yes/No options |
| Single date or datetime | Date | Rich_text with date string |
| Date range (start + end) | Date (with end) | Two separate date properties |
| File attachment | Files | URL property with download link |

## Input Section Pattern

| Method | When to Use | Filter Pattern |
|--------|------------|---------------|
| Simple | ≤3 input fields, low friction | `<COMPLETE_FIELD> = unchecked` |
| OR-required | 4+ required fields, data quality matters | `field1 empty OR field2 empty OR ... OR complete unchecked` |
| Auto-fill | Repetitive defaults (same date, same category) | Same as above + rules to pre-populate on creation |

Convention:
- Mark input sections with yellow background for visual distinction.

## View Design Checklist
For every new database, create at minimum:
- [ ] Input view (data entry point)
- [ ] Active/current view (what's in progress)
- [ ] Archive/complete view (what's done)
- [ ] At least one analytical view (calendar, timeline, gallery, or grouped)

## Cross-References
- For API call patterns when creating databases: see `references/api-patterns.md`
- For base schema templates: see `examples/schema-template.sql`
- For cross-DB relation patterns: see `references/cross-db-workflow.md`
