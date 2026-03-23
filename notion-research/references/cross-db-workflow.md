# Cross-Database Workflow

## Hub and Spoke Model

- Hub entity: project record in a Projects-style database.
- Spoke entities: literature, experiments, notes, milestones, writing items.
- Relation rule: every spoke entry links to exactly one project relation.
- Outcome: project-level filtering, timeline tracking, and continuity stay consistent.

Operational constraints:
- Set relation at creation time when possible.
- Avoid free-text project names; use relation links only.

## Common Workflows

### 1) Add paper + link project

1. Create literature entry (`notion-create-pages`) with title, status, and metadata.
2. Set `Project` relation in the same create payload.
3. If relation cannot be set at create time, run immediate follow-up update.
4. Verify entry appears in project-scoped literature view.

### 2) Log experiment + create linked note

1. Create experiment entry with lifecycle state (`Designed`/`Setup`/etc.).
2. Attach `Project` relation.
3. Create note entry describing setup rationale or observation.
4. Link note to the same project, and to experiment relation if present in schema.

### 3) Track milestone + link project

1. Create milestone entry with category and due date.
2. Set milestone status (`Upcoming` by default unless explicit override).
3. Attach `Project` relation at creation.
4. Maintain one project-scoped milestone view sorted by due date ascending.

### 4) Start writing + attach references

1. Create writing pipeline entry with initial stage (`Outline` unless explicit override).
2. Link writing entry to project relation.
3. Attach reference relations for known relevant literature pages.
4. Update stage and progress as drafting advances.

## Filtered Views

Project-scoped filter pattern:

```text
FILTER "Project" = "<project-page-url>"
```

Naming convention examples:
- `Literature - <Project Name>`
- `Experiments - <Project Name>`
- `Milestones - <Project Name>`
- `Writing - <Project Name>`

Recommended practice:
- Keep exactly one canonical project-scoped operational view per spoke.
- Add sort after filter (for example due date ascending, last edited descending).

## Anti-Patterns

1. Creating spoke entries without a project relation.
2. Using free-text project names instead of relation links.
3. Mixing unrelated projects in one operational view.
4. Leaving status unset at creation time.
