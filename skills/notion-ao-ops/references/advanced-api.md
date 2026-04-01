<!-- Salvaged from notion-io v1.1.1 (2026-03-17) during notion-tooling-retirement -->
<!-- Source sections: §5 Markdown API Patterns, §8 Notion-Flavored Markdown Syntax -->

## Markdown API Patterns

Available from `NotionClient` (Wave 1 upgrade). Uses `PATCH /v1/pages/{page_id}/markdown`.

> **Two-step content pattern** — Always separate structure from narrative:
> 1. **Create/update properties** with `notion-create-pages` or `notion-update-page` (use `update_properties`)
> 2. **Add body content** with `notion-update-page` → `replace_content` or `update_content`
> Never put content longer than ~200 chars in a `rich_text` property — use the page body instead.

### `get_page_markdown(page_id)` — retrieve full page content

```python
from tools.notion.client import NotionClient

client = NotionClient(token=os.environ["NOTION_API_TOKEN"])

# Fetch the full markdown body of a page
markdown_text = await client.get_page_markdown(page_id="<page-uuid>")
print(markdown_text)
```

Returns the entire page body as a Markdown string (response field: `response["markdown"]`).

### `patch_page_markdown` — three operations

#### `update_content` — targeted search-and-replace

```python
await client.patch_page_markdown(
    page_id="<page-uuid>",
    operation="update_content",
    content="New section text.\n",
    old_str="Old section text."
)
```

### Full-Body Replacement Pattern

`update_content` is a search-replace operation, not an implicit "replace all" mode.
To replace the entire body on an existing page, pass the full current markdown as `old_str`.

```python
existing_markdown = await client.get_page_markdown(page_id="<page-uuid>")

await client.patch_page_markdown(
    page_id="<page-uuid>",
    operation="update_content",
    content="# New Body\n\nCompletely replaced content.\n",
    old_str=existing_markdown,
)
```

This works because `old_str` exactly matches the full body, so the update replaces all content.
For new or empty pages, use `insert_content` directly instead of round-tripping with `get_page_markdown`.
If content may have changed between read and write (or is very large), exact matching can fail; use
`replace_content_range` with stable anchors for safer partial updates.

#### `insert_content` — append to page

```python
await client.patch_page_markdown(
    page_id="<page-uuid>",
    operation="insert_content",
    content="\n## Addendum\n\nNew section appended at end.\n"
)
```

#### `replace_content_range` — replace content between string anchors

```python
await client.patch_page_markdown(
    page_id="<page-uuid>",
    operation="replace_content_range",
    content="## Updated Section\n\nReplaced content.\n",
    content_range="## Old Section...end of old section"
)
```

`content_range` must be a string anchor range in the format `"start_anchor...end_anchor"`.

### `bulk_session` — reuse connection across multiple calls

```python
async with client.bulk_session():
    md = await client.get_page_markdown(page_id_1)
    await client.patch_page_markdown(page_id_2, operation="insert_content", content="# New Section\n")
    results = await client.query_database(data_source_id, filter={})
```

Single shared `aiohttp.ClientSession` avoids per-request connection overhead.

---

## Notion-Flavored Markdown Syntax

These are Notion-Flavored Markdown extensions. Standard markdown is always accepted.

### Callout (`:::`)

Description: Renders an icon/color callout block for emphasis.
Usage note: Close with `:::` and keep attributes in the opening tag.

```markdown
::: callout {icon="💡" color="yellow_bg"}
Callout content here. **Bold**, lists, etc. supported.
:::
```

### Toggle (`<details>`)

Description: Creates a collapsible section with hidden content.
Usage note: Inner content should be indented to stay inside the toggle.

```markdown
<details>
<summary>Toggle title</summary>
	Content inside toggle (must be indented)
</details>
```

### Columns (`<columns>`)

Description: Splits content into side-by-side column blocks.
Usage note: Use matching `<column>...</column>` pairs inside `<columns>`.

```markdown
<columns>
<column>
Left column content
</column>
<column>
Right column content
</column>
</columns>
```

### Table (`<table>`)

Description: Creates a structured table block with header row support.
Usage note: Use `<tr>` and `<td>` tags; `header-row` controls header rendering.

```markdown
<table header-row="true" fit-page-width="true">
	<tr>
		<td>**Header 1**</td>
		<td>**Header 2**</td>
	</tr>
	<tr>
		<td>Data 1</td>
		<td>Data 2</td>
	</tr>
</table>
```

### Mention (`<mention-...>`)

Description: Inserts inline references to pages, databases, users, or dates.
Usage note: Mention tags are self-describing by target type; pass the required URL/start attributes.

```markdown
<mention-page url="page-url">Page Name</mention-page>
<mention-database url="db-url">DB Name</mention-database>
<mention-user url="user-url">User</mention-user>
<mention-date start="2026-03-11"/>
```

### Color (`{color=...}` and `<span color>`)

Description: Applies block-level or inline text/background color.
Usage note: Available colors: gray, brown, orange, yellow, green, blue, purple, pink, red; add `_bg` for background variants.

```markdown
<!-- Block color -->
Text {color="blue"}

<!-- Inline color -->
<span color="red">red text</span>
```

### Synced Block (`<synced_block>`)

Description: Defines reusable shared content and references to it.
Usage note: Original block uses `<synced_block>`; references require `url` with `<synced_block_reference>`.

```markdown
<!-- Create original (no url) -->
<synced_block>
	Content to share
</synced_block>

<!-- Reference (url required) -->
<synced_block_reference url="synced-block-url">
	Synced content
</synced_block_reference>
```

---

## Pagination

**Hard limit**: Notion returns at most 100 results per call (`page_size: 100`).

**Signal fields** in every response:
- `has_more: true` → more pages exist
- `next_cursor: "<string>"` → opaque cursor for next page

**Loop pattern** (Python):

```python
results = []
start_cursor = None

while True:
    payload = {
        "filter": my_filter,
        "sorts": my_sorts,
        "page_size": 100,
    }
    if start_cursor:
        payload["start_cursor"] = start_cursor

    response = await client.query_database(data_source_id, **payload)
    results.extend(response["results"])

    if not response.get("has_more"):
        break
    start_cursor = response.get("next_cursor")
```

**Via MCP** — pass `start_cursor` from previous response until `has_more` is `false`:

```json
{
  "data_source_id": "<DATA_SOURCE_ID>",
  "filter": { "property": "Status", "select": { "equals": "new" } },
  "page_size": 100,
  "start_cursor": "<next_cursor from previous response>"
}
```

**Budgeting**: For large datasets (>500 items), cap early with a `limit` argument. The Python client's `query_database()` accepts `limit=` and stops fetching once reached.

---

## Rate Limiting

3 requests/second (enforced by `NotionClient._throttle`). Exponential backoff on 429: 1s, 2s, 4s (max 3 retries). When running multi-page pagination loops, use `bulk_session()` context manager to share a single connection pool.

---

## Python Client Patterns

Initialize the client:

```python
import os
from tools.notion.client import NotionClient

client = NotionClient(token=os.environ["NOTION_API_TOKEN"])
```

Use `bulk_session()` to reuse a single connection pool across multiple calls:

```python
async with client.bulk_session():
    md = await client.get_page_markdown(page_id_1)
    await client.patch_page_markdown(page_id_2, operation="insert_content", content="# New Section\n")
    results = await client.query_database(data_source_id, filter={})
```

Single shared `aiohttp.ClientSession` avoids per-request connection overhead.

---

## Advanced Property Shapes

Construct property dicts for `notion-update-page` or `client.create_page()`. These types extend the basic shapes in `api-patterns.md`.

### relation

Relations store page IDs — NOT names.

```json
{
  "Reference Set": {
    "relation": [
      { "id": "page-uuid-1" },
      { "id": "page-uuid-2" }
    ]
  }
}
```

**MCP limitation**: `notion-update-page` runs URL validation first and rejects relation UUID payloads. For relation writes, use the Python helper `client.set_relation(...)`:

```python
await client.set_relation(
    page_id="<research-project-page-id>",
    property_name="Literature",
    related_page_ids=["<literature-page-id-1>", "<literature-page-id-2>"],
)
```

### people

**MCP format** (`notion-create-pages` / `notion-update-page`) — JSON array of user IDs:

```json
{
  "Collaborators": ["user-uuid-1", "user-uuid-2"]
}
```

**Python client** (`client.create_page()`) — raw API format:

```json
{
  "Collaborators": {
    "people": [{ "object": "user", "id": "user-uuid-1" }]
  }
}
```

### file

Remote OAuth MCP does not support file upload for `files` properties. Treat them as **read-only** in MCP flows.

```json
{
  "PDF": [
    {
      "name": "paper.pdf",
      "type": "file",
      "file": {
        "url": "https://file.notion.so/.../paper.pdf"
      }
    }
  ]
}
```

### rollup

Rollup properties recompute server-side and are **read-only** — cannot be written via the API. Attempting to `PATCH` a rollup will silently fail or return a 400. Compute aggregates in Python instead.

### created_time

`created_time` properties are auto-set by Notion and are **read-only**.

```json
{
  "Added": "2026-03-11T02:15:47.000Z"
}
```
