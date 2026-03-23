# Formulas & Automation

Notion databases become powerful when they compute, filter, and connect automatically. Most people start with “store rows and sort them,” but the real leverage appears when formulas remove repetitive decisions and relations stop being manual chores. This chapter is a practical walkthrough from core logic to scalable automation patterns. You will start with three tiny building blocks, then layer in Formula 2.0 features, and finally connect everything with relation automation.

The core mindset is simple:

1. **Write logic as small testable pieces** (not one giant expression).
2. **Use Formula 2.0 features to reduce repetition** (`let`, `lets`, list operations).
3. **Automate relation linking at the process level** so formulas always have connected data.

When these three are in place, your database stops acting like a static table and starts behaving like a lightweight logic engine.

## Formula 2.0 — What Changed

Formula 2.0 matters because it improved both **expressiveness** and **maintainability**. In practice, this means you can build longer formulas without losing readability, and you can query related data more directly.


| Area | Formula 1.0 | Formula 2.0 | Why it matters in real workflows |
|---|---|---|---|
| Writing direction | Horizontal, spreadsheet-like chaining | Vertical, code-like structure | Easier to scan, indent, and debug long formulas |
| Comments | Not available | Available | You can annotate intent inside complex logic |
| Variables | Not available | `let()` / `lets()` | Reuse intermediate values instead of repeating the same expression |
| Rollup dependency | High | Lower (more direct relation-list processing) | Fewer helper properties; cleaner schemas |
| Type mixing in branches | Strict and awkward | More flexible | Cleaner output when combining labels + numeric results |
| Arrays / lists | Limited | First-class list workflows (`filter`, `map`, etc.) | Powerful relation analytics directly in formula properties |

### Practical impact checklist

- If your formula repeats the same relation traversal 3+ times, 2.0 lets you move it into a variable.
- If your logic had to be split into many helper properties, 2.0 often lets you consolidate.
- If your team struggles to read formulas, comments + vertical formatting reduce maintenance cost.

In short: Formula 2.0 is not just “new syntax.” It changes how you model logic in Notion databases.

## The Three Building Blocks

Before advanced functions, master these three primitives: `empty()`, `not`, and `and`. They are enough to handle most validation and classification logic.


### 1) `empty(value)` — detect missing input

Use `empty()` whenever your decision depends on whether a field is filled.

```notion
empty(prop("Credit"))
```

Returns `true` when no value is present.

### 2) `not(boolean)` — invert a condition

Often used as “has value”:

```notion
not(empty(prop("Credit")))
```

This reads naturally as: “Credit field is not empty.”

### 3) `and(conditionA, conditionB)` — combine strict conditions

`and()` requires **exactly two arguments**. For three or more conditions, nest it.

```notion
and(cond1, and(cond2, cond3))
```

If you try `and(cond1, cond2, cond3)`, you get an argument-count error.

### Worked Example: Payment Method Auto-Detection

Assume three properties:

- `Cash` (checkbox)
- `Credit` (text)
- `Bank` (text)

Goal:

- `💵 Cash` when only Cash is selected
- `💳 Credit Card` when only Credit has text
- `🏦 Bank Transfer` when only Bank has text
- empty string when none selected
- `❌ Error` when multiple methods are entered simultaneously

```notion
ifs(
  and(prop("Cash"), and(empty(prop("Credit")), empty(prop("Bank")))), "💵 Cash",
  and(not(prop("Cash")), and(not(empty(prop("Credit"))), empty(prop("Bank")))), "💳 Credit Card",
  and(not(prop("Cash")), and(empty(prop("Credit")), not(empty(prop("Bank"))))), "🏦 Bank Transfer",
  and(not(prop("Cash")), and(empty(prop("Credit")), empty(prop("Bank")))), "",
  "❌ Error"
)
```

This pattern teaches two important habits:

1. **Explicit exclusivity** (each valid case blocks the other inputs).
2. **Final catch-all** (`"❌ Error"`) to catch contradictory input.

## Key Functions

Formula 2.0 adds functions that dramatically reduce repeated logic. Below are practical examples you can adapt directly.


### `let(name, value, expr)` / `lets(n1, v1, n2, v2, ..., expr)`

Use when you compute an intermediate value once and reuse it.

```notion
let(doneCount,
  prop("Tasks").filter(current.prop("Status") == "Done").length,
  "Done: " + doneCount
)
```

Use case: avoid recalculating expensive list expressions.

```notion
lets(
  total, prop("Tasks").length,
  done, prop("Tasks").filter(current.prop("Status") == "Done").length,
  if(total == 0, "No tasks", format(round(done / total * 100)) + "% complete")
)
```

Use case: reusable totals + percentages in one readable block.

### `filter(list, condition)`

Keep only list items that satisfy a condition.

```notion
prop("Tasks")
  .filter(current.prop("Status") == "Done")
  .length
```

Use case: count completed items from a related tasks list.

```notion
prop("Tasks")
  .filter(current.prop("Priority") == "High")
  .map(current.prop("Title"))
```

Use case: return only high-priority task names for quick review.

### `match(array, pattern)`

Use pattern matching to find array entries that match a target pattern.

```notion
match(prop("Tags"), "bug").length
```

Use case: count how many selected tags include a specific label.

```notion
if(match(prop("Keywords"), "urgent").length > 0, "🔥 Action now", "")
```

Use case: trigger a warning label if an urgency keyword appears.

### `ifs(c1, v1, c2, v2, ..., default)`

Cleaner alternative to deeply nested `if()` chains.

```notion
ifs(
  prop("Score") >= 90, "A",
  prop("Score") >= 80, "B",
  prop("Score") >= 70, "C",
  "Needs Review"
)
```

Use case: graded or staged classification rules.

```notion
ifs(
  empty(prop("Due")), "No deadline",
  prop("Done"), "✅ Complete",
  "⏳ In progress"
)
```

Use case: compact status labels from mixed boolean/date input.

### `dateRange(start, end)`

Create a date span from two date endpoints.

```notion
dateRange(prop("Start Date"), prop("End Date"))
```

Use case: produce a single timeline-ready period field from two inputs.

```notion
let(endDate, dateAdd(prop("Start Date"), 6, "days"),
  dateRange(prop("Start Date"), endDate)
)
```

Use case: auto-generate one-week windows from a start date.

## Relation Automation

Most teams hit the same bottleneck: relation fields are powerful, but manually linking records does not scale. As data volume grows, users forget to connect rows, formulas lose context, and reporting becomes inconsistent.


The scalable answer is a **relation automation pattern**:

1. **Submit event** receives structured input.
2. For each relation target, **search target DB** by a unique key.
3. **Create-or-update decision**:
   - If target exists: update or reuse it.
   - If target missing: create it first.
4. **Link relation** from the main record to the resolved target record.
5. Repeat for each related dimension (for example: person, company, category).

Why this pattern works:

- It prevents duplicate reference rows.
- It keeps relation integrity high from day one.
- It guarantees formulas depending on relations always have connected source data.

### Design principles (platform-agnostic)

- **Use stable keys** for lookup (slug, email, ID, normalized name).
- **Separate lookup from creation** so the flow is auditable.
- **Handle missing/ambiguous keys explicitly** (fallback queue or review status).
- **Keep relation writes idempotent** (re-running should not create duplicates).

Even if your stack changes, this pattern remains the same. The implementation tool can vary, but the decision logic should not.

## Tips

These habits make formulas and automation easier to maintain over time.



### 1) Build in pieces

Don’t write a full 20-line formula in one pass. Build and test small chunks:

- first: raw condition
- then: one valid branch
- then: additional branches
- finally: error/default branch

This lowers syntax errors and makes logic review faster.

### 2) Use the “complete button” test

A practical validation habit: after editing logic, test the action path that depends on it (for many workflows, this is your completion/submit action). If that flow fails or disables unexpectedly, inspect your latest formula change first.

### 3) Use emoji in output labels

Status labels become easier to scan when visually encoded:

- `✅ Complete`
- `⏳ In progress`
- `❌ Error`

Tiny visual cues reduce cognitive load in dense tables.

### 4) Nest `and()` for 3+ conditions

Because `and()` takes exactly two arguments, always nest when combining three or more checks:

```notion
and(cond1, and(cond2, and(cond3, cond4)))
```

Treat this as a structural rule, not a workaround.

### 5) Use `lets()` for repeated patterns

When relation traversals or counts repeat, move them into named variables. Benefits:

- fewer repeated expressions
- easier formula edits
- clearer intent for collaborators

If you see the same expression pasted multiple times, `lets()` is usually the right refactor.

---

The progression is straightforward: master `empty/not/and`, adopt Formula 2.0 patterns (`let`, `lets`, list functions), then enforce relation automation so your formulas always receive good connected data. Once these pieces are in place, your databases stop being passive records and become reliable operational systems.
