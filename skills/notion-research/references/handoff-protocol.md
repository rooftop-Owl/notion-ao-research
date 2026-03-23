# Handoff Protocol

## What

- Handoff context is a text property on the project database.
- Required compact format:
  - `CURRENT: <active focus>`
  - `NEXT: <immediate next step>`
  - `BLOCKERS: <blocking issue or none>`
- Keep the full block at or below 500 characters.

## Read

Read handoff context from the project page via `notion-fetch`:

```yaml
notion-fetch:
  id: "<project-page-id>"
```

Inspect the project properties and read `Handoff Context` as plain text.

## Write

Use `notion-update-page` with `update_properties`.
For MCP payload shape, write a plain string value (not a rich_text object).

```yaml
notion-update-page:
  page_id: "<project-page-id>"
  command: "update_properties"
  properties:
    Handoff Context: "CURRENT: Validate relation sync\nNEXT: Patch find-then-update fallback\nBLOCKERS: Waiting on access token"
```

## Hook Integration

Any platform with session lifecycle hooks can write this automatically at session end.
Recommended behavior:
- Build a compact summary from terminal session state.
- Replace stale handoff block atomically.
- Skip write safely when credentials/config are unavailable.

## Anti-Patterns

1. Overwriting newer handoff text with stale summaries.
2. Exceeding 500 characters and losing readability.
3. Omitting one of the required keys (`CURRENT`, `NEXT`, `BLOCKERS`).
4. Mixing payload shapes across transports (MCP plain string vs direct API rich_text).
5. Writing handoff narrative into page body instead of the dedicated property.

## Quick Template

```text
CURRENT: <what is actively being worked>
NEXT: <next concrete action>
BLOCKERS: <blocking dependency, risk, or none>
```
