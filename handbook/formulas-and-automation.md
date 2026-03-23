# Formulas & Automation

> **What you'll learn:** How to make Notion databases compute, filter, and connect automatically — from three primitive building blocks to Formula 2.0 patterns to relation automation.
>
> - The 3 building blocks: `empty()`, `not`, `and`
> - Formula 2.0 features: `let`, `lets`, `filter`, `match`, `ifs`, `dateRange`
> - Relation automation pattern (platform-agnostic)
> - Practical tips for maintainable formulas

**See also:** [Design Methodology](./design-methodology.md) for the database architecture these formulas operate on. · [Principles](./principles-and-antipatterns.md) for the "don't make it a chore" principle that motivates automation.

---

## Table of Contents

- [Formula 2.0 — What Changed](#formula-20--what-changed)
- [The Three Building Blocks](#the-three-building-blocks)
- [Key Functions](#key-functions)
- [Relation Automation](#relation-automation)
- [Tips](#tips)

---

Notion databases become powerful when they compute, filter, and connect automatically. Most people start with "store rows and sort them," but the real leverage appears when formulas remove repetitive decisions and relations stop being manual chores.

The core mindset is simple:

1. **Write logic as small testable pieces** (not one giant expression).
2. **Use Formula 2.0 features to reduce repetition** (`let`, `lets`, list operations).
3. **Automate relation linking at the process level** so formulas always have connected data.

When these three are in place, your database stops acting like a static table and starts behaving like a lightweight logic engine.

---

## Formula 2.0 — What Changed

Formula 2.0 improved both **expressiveness** and **maintainability**. You can build longer formulas without losing readability, and query related data more directly.

| Area | Formula 1.0 | Formula 2.0 | Why it matters |
|---|---|---|---|
| Writing direction | Horizontal, spreadsheet-like | Vertical, code-like | Easier to scan, indent, debug |
| Comments | Not available | Available | Annotate intent inside complex logic |
| Variables | Not available | `let()` / `lets()` | Reuse intermediate values |
| Rollup dependency | High | Lower (direct relation-list access) | Fewer helper properties, cleaner schemas |
| Type mixing | Strict and awkward | More flexible | Cleaner combined labels + numbers |
| Arrays / lists | Limited | First-class (`filter`, `map`, etc.) | Powerful relation analytics in formula |

> [!TIP]
> **Quick self-check:** If your formula repeats the same relation traversal 3+ times → move it into a `let` variable. If your logic needed helper properties → Formula 2.0 probably lets you consolidate. If your team can't read formulas → comments + vertical formatting fix that.

---

## The Three Building Blocks

Before advanced functions, master these three primitives. They are enough to handle most validation and classification logic.

### 1) `empty(value)` — detect missing input

```javascript
empty(prop("Credit"))  // true when no value is present
```

> [!NOTE]
> Numbers: `0` counts as empty. Text: `""` counts as empty.

### 2) `not(boolean)` — invert a condition

The "has value" pattern:

```javascript
not(empty(prop("Credit")))  // "Credit field is not empty"
```

Only works on boolean values — you cannot use `not` on numbers, text, or dates directly.

### 3) `and(conditionA, conditionB)` — combine strict conditions

> [!WARNING]
> **`and()` takes exactly 2 arguments.** This is the #1 error new users hit. For three or more conditions, nest:
> ```javascript
> and(cond1, and(cond2, cond3))  // ✅ Correct
> and(cond1, cond2, cond3)       // ❌ "Too many arguments" error
> ```

---

### Worked Example: Payment Method Auto-Detection

Three properties: `Cash` (checkbox), `Credit` (text), `Bank` (text).

Goal: auto-detect which payment method is used, catch conflicts.

<details>
<summary>Full formula (click to expand)</summary>

```javascript
ifs(
  and(prop("Cash"), and(empty(prop("Credit")), empty(prop("Bank")))),
    "💵 Cash",
  and(not(prop("Cash")), and(not(empty(prop("Credit"))), empty(prop("Bank")))),
    "💳 Credit Card",
  and(not(prop("Cash")), and(empty(prop("Credit")), not(empty(prop("Bank"))))),
    "🏦 Bank Transfer",
  and(not(prop("Cash")), and(empty(prop("Credit")), empty(prop("Bank")))),
    "",
  "❌ Error"
)
```

</details>

This pattern teaches two habits:
1. **Explicit exclusivity** — each valid case blocks the other inputs.
2. **Final catch-all** (`"❌ Error"`) — contradictory input is caught, not silently ignored.

> [!NOTE]
> **Key takeaway:** Every conditional formula should have a catch-all branch. Silent failures are the worst kind.

---

## Key Functions

Formula 2.0 adds functions that dramatically reduce repeated logic.

### `let` / `lets` — Named Variables

Compute once, reuse everywhere:

```javascript
let(doneCount,
  prop("Tasks").filter(current.prop("Status") == "Done").length,
  "Done: " + doneCount
)
```

Multiple variables with `lets`:

```javascript
lets(
  total, prop("Tasks").length,
  done, prop("Tasks").filter(current.prop("Status") == "Done").length,
  if(total == 0, "No tasks", format(round(done / total * 100)) + "% complete")
)
```

### `filter(list, condition)` — Subset a Related List

```javascript
prop("Tasks").filter(current.prop("Status") == "Done").length
// → Count completed items from a related tasks list

prop("Tasks").filter(current.prop("Priority") == "High").map(current.prop("Title"))
// → Return only high-priority task names
```

### `match(array, pattern)` — Find Matching Items

```javascript
match(prop("Tags"), "bug").length
// → Count tags containing "bug"

if(match(prop("Keywords"), "urgent").length > 0, "🔥 Action now", "")
// → Trigger warning label if urgency keyword appears
```

### `ifs(c1, v1, c2, v2, ..., default)` — Clean Multi-Conditional

Replaces deeply nested `if()` chains:

```javascript
ifs(
  prop("Score") >= 90, "A",
  prop("Score") >= 80, "B",
  prop("Score") >= 70, "C",
  "Needs Review"
)
```

### `dateRange(start, end)` — Create Date Spans

```javascript
dateRange(prop("Start Date"), prop("End Date"))
// → Single timeline-ready period from two dates

let(endDate, dateAdd(prop("Start Date"), 6, "days"),
  dateRange(prop("Start Date"), endDate)
)
// → Auto-generate one-week windows from a start date
```

---

## Relation Automation

Most teams hit the same bottleneck: relation fields are powerful, but manually linking records does not scale.

> [!WARNING]
> As data volume grows, users forget to connect rows, formulas lose context, and reporting becomes inconsistent. Manual relations are a scalability trap.

### The Pattern (platform-agnostic)

```text
Submit event
    ↓
Search target DB by unique key
    ↓
┌─────────────────────┐
│ Target exists?       │
├─── YES → reuse it   │
├─── NO  → create it  │
└─────────────────────┘
    ↓
Link relation from main record to resolved target
    ↓
Repeat for each related dimension (person, company, category...)
```

### Design Principles

- **Use stable keys** for lookup (slug, email, ID, normalized name)
- **Separate lookup from creation** so the flow is auditable
- **Handle missing/ambiguous keys explicitly** (fallback queue or review status)
- **Keep relation writes idempotent** (re-running should not create duplicates)

> [!NOTE]
> Even if your implementation tool changes, this pattern remains the same. The decision logic is what matters — not the platform.

---

## Tips

> [!TIP]
> **Build in pieces.** Don't write a 20-line formula in one pass. Build and test small chunks: raw condition → one branch → additional branches → error/default.

| Tip | Why |
|-----|-----|
| Build in pieces | Lowers syntax errors, makes review faster |
| Use the "complete button" test | If your completion flow breaks, inspect the latest formula change first |
| Emoji in output labels (`✅`, `⏳`, `❌`) | Tiny visual cues reduce cognitive load in dense tables |
| Nest `and()` for 3+ conditions | Structural rule, not a workaround — `and(c1, and(c2, c3))` |
| Use `lets()` for repeated patterns | Fewer expressions, easier edits, clearer intent |

---

> [!NOTE]
> **The progression:** Master `empty/not/and` → adopt Formula 2.0 patterns (`let`, `lets`, list functions) → enforce relation automation. Once these pieces are in place, your databases stop being passive records and become reliable operational systems.
>
> **See also:** [Design Methodology](./design-methodology.md) for the database patterns these formulas power. · [Principles](./principles-and-antipatterns.md) for why "don't make it a chore" drives all of this.
