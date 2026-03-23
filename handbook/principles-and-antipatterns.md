# Principles & Anti-Patterns

> **What you'll learn:** The 3 foundational rules (in Korean and English) that separate lasting Notion workspaces from beautiful garbage, plus the 7 most common anti-patterns that kill adoption.
>
> - The three principles: 심플하게, 직관적으로, 일이 되지 않게
> - When to use icons (4 criteria) and when to remove them
> - Naming conventions that encode behavior
> - Anti-patterns with concrete fixes

**See also:** [Design Methodology](./design-methodology.md) for the architecture that implements these principles. · [Formulas & Automation](./formulas-and-automation.md) for the tools that enforce them.

---

## Table of Contents

- [The Three Principles](#the-three-principles)
- [Icon Rules](#icon-rules)
- [Naming Conventions](#naming-conventions)
- [Anti-Patterns](#anti-patterns)
- [Operational Rules to Keep the System Alive](#operational-rules-to-keep-the-system-alive)

---

These rules come from years of building and rebuilding Notion workspaces. They separate lasting systems from beautiful garbage.

Most Notion failures are not technical failures. They are design failures. People open a blank page, decorate it, feel productive for one evening, and abandon it by week two. Why? Because the system asks for too much input, hides important states behind visual noise, and lacks a single source of truth. A good workspace is not the one that looks impressive in screenshots. A good workspace is the one you can still use when you are tired, rushed, and slightly annoyed.

This chapter is opinionated on purpose. If a rule here feels strict, keep it anyway until you have enough evidence to break it. Consistency beats creativity in system design.

---

## The Three Principles

### 1) 심플하게 — Keep It Simple

Pretty and simple are different. Over-decoration is **이쁜 쓰레기 (beautiful garbage)**.

Notion gives you too many visual toys: icons, covers, callouts, dividers, emoji labels, aesthetic dashboards. None of these are bad by themselves. They become bad when they interrupt input and retrieval. A system exists to capture and surface data. If decoration slows either step, decoration is not design. It is friction.

> [!IMPORTANT]
> **Rule:** If a design element does not serve data entry or retrieval, remove it.

Practical interpretation:
- If you cannot explain an element in one sentence ("this helps me input faster" or "this helps me find records faster"), delete it.
- If a page needs a long legend to explain color meaning, your structure is weak.
- If you spend more time aligning blocks than defining properties, you are building theater, not a system.

Simplicity is not minimalism for aesthetics. Simplicity is operational clarity. You should be able to open a workspace at 11:30 PM and know exactly where to type, what to check, and what happens next.

### 2) 직관적으로 — Make It Intuitive

Intuition is not magic. It is the result of consistent conventions.

People call a workspace "not intuitive" when it keeps changing its own language. One table uses emoji status, another uses text status, a third uses icons with no labels. One page uses yellow for urgent items, another uses yellow for input areas. Users do not fail because they are careless; they fail because the system is inconsistent.

> [!IMPORTANT]
> **Rule:** Establish your own guidelines and stick to them. Can someone new find where to enter data in 30 seconds?

Core convention examples (use or adapt, but do not mix randomly):
- **Yellow = input area** (노란색 = 입력 구역)
- **Table icon = master table** (테이블 아이콘 = 마스터 테이블)
- **No icon = regular data page** (아이콘 없음 = 일반 데이터 페이지)

> [!TIP]
> **The 30-second test:** Give a page to someone unfamiliar. If they cannot identify where to input data in 30 seconds, your design failed. Don't explain it away. Redesign it.

### 3) 일이 되지 않게 — Don't Make It a Chore

The biggest risk in Notion is not complexity. It is fatigue.

Any workflow that feels like clerical labor will die. If users must repeatedly type the same date, category, relation, and status for every new row, they will eventually stop entering data. Once input breaks, every dashboard becomes stale and every formula becomes fiction.

> [!IMPORTANT]
> **Rule:** If you enter the same value 3+ times, automate it.

Automation baseline:
- Auto-fill dates on record creation.
- Auto-categorize default types when context is obvious.
- Auto-link common relations (or provide a constrained quick-select path).
- Use formulas/rules for derived fields, never manual copy-paste.

"Don't make it a chore" does not mean "make it fancy." It means remove repetitive keystrokes. Every repeated manual step is a debt payment. Reduce debt early.

> [!NOTE]
> **Key takeaway:** The 3 principles are a priority stack. When in conflict: simplicity > intuition > automation. A simple system that's slightly manual beats a complex automated system that nobody understands.

---

## Icon Rules

Default policy: **No icons on data pages** (데이터 페이지 기본 아이콘 없음).

Why this default matters:
1. **Icons hide content state.** In Notion, content/no-content visual cues are useful. Arbitrary icons flatten that signal.
2. **Icon selection becomes labor.** Hundreds of choices create decision fatigue for zero operational gain.
3. **Visual noise scales badly.** A few icons feel harmless; hundreds destroy scanability.

> [!WARNING]
> If you add icons to every page "because it looks nice," you are creating maintenance debt. When you have 200+ pages, icon management becomes a job. Stop before it starts.

Use icons **only** if at least one of the following four exceptions applies:

| # | Exception | Why Icon Helps |
|---|-----------|---------------|
| 1 | **Navigation buttons** (네비게이션 버튼) | Pages that exist as click targets — icon makes them look interactive |
| 2 | **Master tables** (마스터 테이블) | Core databases that must be quickly distinguishable from linked views |
| 3 | **Category/relation pages** (카테고리/관계형) | Classification nodes where visual grouping improves recognition in rollups |
| 4 | **External-facing pages** (외부 공개형) | Marketing/recruiting/showcase where presentation is a first-class objective |

If a page does not meet one of these four criteria, remove its icon. No debate. This single rule dramatically improves clarity in large workspaces.

---

## Naming Conventions

Naming is behavior design. A property name should tell users what to do, not merely what the field is.

### 1) Master table names in English

Keep master table names in English and keep them stable. This is less about language preference and more about consistent indexing and cross-page readability:
- `Tasks`, `Projects`, `Meetings`, `References`, `Contacts`

> [!TIP]
> Do not rename tables every month. Stability is more valuable than novelty.

### 2) `입력완료 ✓` — The trigger pattern

Use a clear trigger field name such as `입력완료 ✓` (Input Complete ✓) to communicate lifecycle intent. The checkmark is not decoration; it is a workflow contract.

| ❌ Bad Names | ✅ Good Names |
|-------------|--------------|
| `done2` | `입력완료 ✓` |
| `flag` | `Input Complete ✓` |
| `ok?` | `Ready for Processing ✓` |

### 3) Yellow background convention

Yellow means "input happens here." Not urgent. Not important. Not warning. **Input only.**

If yellow means one thing in one page and another thing elsewhere, users lose trust in color cues. A convention only works when it is boringly consistent.

### 4) Lifecycle-order status options

Status options must follow process order, not emotional order or random preference.

```text
✅ Lifecycle order:  Inbox → Input Complete → In Progress → Complete → Archived
❌ Random order:     Urgent, Later, Maybe, Final, Start
```

A status field should encode transition logic. If options don't imply a sequence, they're labels, not lifecycle states.

---

## Anti-Patterns

> [!CAUTION]
> These are the recurring mistakes that make workspaces *look* active while quietly killing usage. If your team keeps asking "Where do I write this?" or "Why did this disappear?", you are likely running at least three of these simultaneously.

| Anti-Pattern | Why It's Bad | Fix |
|---|---|---|
| **Treating Notion as memo app** | Uses maybe 10% of capability; information becomes unstructured text with no reusable properties | Use databases with properties and views from day one |
| **Duplicating data** | No source of truth; conflicts emerge between copies and no one knows which row is correct | Keep one master table and use linked views |
| **Manual everything** | Burnout in 2 weeks; repetitive entry destroys consistency and motivation | Auto-fill defaults, formulas, and automation rules |
| **Icons on every page** | Visual noise hides content status and slows scanning | Apply the 4-criteria icon rule above |
| **Editing in non-input views** | Filter logic breaks; records vanish unexpectedly or bypass required fields | Restrict creation/editing to an Input Section |
| **Complex formulas all at once** | Impossible to debug; one error masks five assumptions | Build formulas in small pieces and validate each part |
| **Over-decorating** | Time is spent on layout theater, not data quality | Structure first, decoration never |

---

## Operational Rules to Keep the System Alive

1. **One source of truth first, views second.**
   New request for a "new page" usually means "new view," not "new database."

2. **Input path must be obvious and fast.**
   Prefer table-based input for speed. Keyboard-friendly workflows win over mouse-heavy workflows.

3. **Conventions beat preferences.**
   Team-level consistency is more important than personal aesthetics.

4. **Automate after third repetition.**
   The first repetition is a signal; the third is a design bug.

5. **Audit quarterly.**
   Remove dead properties, merge duplicate statuses, and re-test the 30-second input discovery rule.

---

> [!NOTE]
> **Final word:** If your workspace follows the 3 Principles and avoids these anti-patterns, it will outlast any template you download.
>
> **See also:** [Design Methodology](./design-methodology.md) to build the architecture. · [Formulas & Automation](./formulas-and-automation.md) to make it self-maintaining.
