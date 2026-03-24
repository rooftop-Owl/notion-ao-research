# Design Methodology

> **What you'll learn:** The complete architecture for designing a Notion workspace that lasts — from your first database to a multi-table system with automatic data flow.
>
> - Master Table: one source of truth per data type
> - Linked Database Views: same data, multiple perspectives
> - Input Section: the UX pattern that makes or breaks adoption
> - Data Flow: Input → Processing → Complete lifecycle
> - Status Lifecycle Design: states as a directed journey
> - Page Structure: 3 page types for scalable organization
> - Case Study: a full 9-table Digital Library

**See also:** [Principles & Anti-Patterns](./principles-and-antipatterns.md) for the 3 rules underlying this methodology. · [Formulas & Automation](./formulas-and-automation.md) for making databases self-maintaining.

---

## Table of Contents

- [The Master Table](#the-master-table)
- [Linked Database Views](#linked-database-views)
- [The Input Section](#the-input-section)
- [Data Flow: Input → Processing → Complete](#data-flow-input--processing--complete)
- [Status Lifecycle Design](#status-lifecycle-design)
- [Page Structure](#page-structure)
- [Case Study: The Digital Library](#case-study-the-digital-library)

---

Before you create a single database, understand the architecture that makes Notion powerful. This isn't a memo app — it's a platform for building data systems.

If you treat Notion like a blank notebook, you will get a blank notebook: scattered notes, duplicate pages, and constant friction when you try to find anything later. But if you treat Notion as a system design problem, the experience changes completely. You stop "writing into pages" and start building flows: where data enters, how it gets processed, where it is consumed, and when it is considered complete.

> [!IMPORTANT]
> **A good Notion workspace is designed for repeated use, not one-time setup.** Pretty formatting can impress you for a day. Low-friction structure keeps you using the workspace for years.

Think of your workspace as a home kitchen:

- You need one trusted storage area for ingredients.
- You need different surfaces for prep, cooking, and serving.
- You need clear rules so you do not re-chop the same onion every day.

That is exactly what this chapter builds: one source of truth, many purpose-built views, a disciplined input flow, and a clear lifecycle from raw entry to finished outcomes.

---

## The Master Table

Every serious Notion workspace starts with a **Master Table**: one database that stores the original record for a domain (books, tasks, experiments, contacts, classes, etc.).

Use this analogy: the master table is your **master refrigerator**. You do not keep one refrigerator for vegetables, another for milk, and another for leftovers in different houses. You keep one real storage unit, then decide what to take out and where to place it when cooking.

In Notion terms:

1. **One table holds original records.**
2. **Everything else is a view of that same table.**
3. **You do not create parallel databases for the same entity.**

> [!TIP]
> **Master Table rules** — apply these strictly for your first build:
> - Create as **full-page format** (data scales without cramping)
> - Use an **English name** (portability across templates and teams)
> - **Don't hide properties** (this is your audit surface)
> - **Sort by date** (lifecycle and recency stay visible)
> - **Mark with a clear icon** (visually distinct as source of truth)

Why be this strict? Because hidden structure creates hidden errors. Most Notion fatigue comes from losing trust in your own workspace — "Where is the real version?" "Why is this record missing?" The master table pattern prevents that confusion before it starts.

> [!NOTE]
> **Key takeaway:** One master table per data type. Everything else is a view. If you're about to create a second database for the same kind of data — stop and create a linked view instead.

---

## Linked Database Views

Once the master table exists, the next rule is non-negotiable:

> [!IMPORTANT]
> **Don't create new data — create a new VIEW.**

Linked Database Views are not copies you maintain separately. They are different windows into the same data. Change the original record once, and every view reflects it.

Notion offers six view formats — choose based on the question you're asking:

| View | Best for |
|------|---------|
| **Table** | High-density editing, fast keyboard entry |
| **Board** | Stage-based movement (status columns) |
| **Gallery** | Visual scanning (covers, thumbnails, cards) |
| **List** | Compact reading, linear browsing |
| **Calendar** | Date-based planning and retrospectives |
| **Timeline** | Duration and overlap across time |

Same records, different meaning. Imagine a single "Task" record:

- In **Table**, it is a row you can update quickly.
- In **Board**, it appears under "In Progress."
- In **Calendar**, it appears on its due date.
- In **Timeline**, it stretches across the planned week.

You did not create four tasks. You created four perspectives.

> [!WARNING]
> When beginners struggle, they often build separate databases like "Today Tasks," "Weekly Tasks," and "Completed Tasks." It feels organized at first, then collapses into duplication. Linked views solve this permanently with filters, sort rules, grouping, and layout changes.

---

## The Input Section

If the master table is the brain, the **Input Section** is the hands.

> [!IMPORTANT]
> This is the most important UX pattern to learn. Most workspaces fail not because reporting is weak, but because **entering data feels annoying**. Once entry becomes effortful, consistency drops. Then the workspace becomes stale.

The Input Section fixes this by creating one dedicated entry zone, visually distinct (commonly with a **yellow background**), where you capture new records quickly. Once input is complete, records automatically disappear from the input zone and move to the next stage.

### Method 1: Simple filter (best starter)

Use a linked table view with:
- `Complete = unchecked`
- Keep visible fields to **3 or fewer** (Title, Date, Complete)

Fastest adoption path. Enter → check complete → row exits the input view.

### Method 2: OR-required logic (for richer records)

When you have **4+ required fields**, use OR-based conditions that keep a row visible if any critical field is missing:

```text
Title is empty  OR  Date is empty  OR  Priority is empty  OR  Complete is unchecked
```

Only when ALL required values are filled and complete is checked does the row leave input.

### Method 3: Auto-fill defaults (for speed at scale)

Pre-populate predictable values with rules/default behavior (today's date, default category, default rank). The user still owns meaningful fields, but repetitive boilerplate disappears.

> [!TIP]
> **Practical setup for your first workspace:**
> - Make the input block impossible to miss (yellow convention)
> - Put it near the top of the page
> - Use table layout for keyboard-first speed
> - Label the trigger field clearly: `Input Complete ✓`
>
> Your goal: make capture so simple that future-you cannot justify skipping it.

---

## Data Flow: Input → Processing → Complete

Combine master table + linked views + input section into a lifecycle. You are not moving data between databases — you are moving records through **states** inside one database, with filtered views representing each stage.

```text
┌─────────────────────────────────────┐
│  INPUT VIEW                         │
│  filter: Input Complete = false     │
│                                     │
│  → User fills fields, checks ✓      │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  PROCESSING VIEW                    │
│  filter: Input Complete = true      │
│      AND Complete = false           │
│                                     │
│  → User works on item, marks done   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  COMPLETE VIEW                      │
│  filter: Complete = true            │
│                                     │
│  → Archive, reporting, reference    │
└─────────────────────────────────────┘
```

This solves four operational problems:

1. **Clarity** — everyone knows where new items begin
2. **Focus** — processing view contains only actionable work
3. **History** — complete view stores finished records without cluttering active work
4. **Automation readiness** — checkboxes/select states become reliable transition triggers

> [!NOTE]
> **Design principle:** Separate stage by filter, not by storage location. All three views show the same data — the filters create the flow.

---

## Status Lifecycle Design

A status field is not decoration. It is a directed journey.

If your statuses are vague ("Doing," "Done," "Etc"), users hesitate because the next action is unclear. Good lifecycle design makes each state behaviorally meaningful.

**Design rules:**
1. States represent **decision-relevant stages**, not arbitrary labels
2. Transition direction feels obvious to a new user
3. Every state implies a concrete next action

### Example lifecycles

| Domain | Lifecycle |
|--------|----------|
| **Books** | `Wishlist → Ready → Reading → Read → Studying → Study Complete → Review Written` |
| **Tasks** | `Inbox → Clarified → Scheduled → In Progress → Blocked → Done` |
| **Experiments** | `Idea → Designed → Running → Analyzing → Validated → Documented` |

These are not universal templates — they are architecture examples. Your job is to model your real workflow as a journey where each state signals intention and next move.

> [!TIP]
> If you design this well, your filters, boards, reports, and reminders become easy — they all reference one coherent state machine.

---

## Page Structure

As your workspace grows, page-level information architecture matters as much as database design.

### The 3 Page Types

| Type | Purpose | Contains |
|------|---------|---------|
| **Master Table** | Data warehouse | Inline master tables |
| **Storage** | Warehouse district | Groups of master table pages |
| **Information** | Display showroom | Linked database views for daily use |

```text
Workspace
└── Knowledge Hub (Information)
    ├── Daily Input (linked views)
    ├── Reading Dashboard (linked views)
    ├── Weekly Review (linked views)
    └── Data Storage (Storage)
        ├── Book_Master (Master Table)
        ├── Notes_Master (Master Table)
        └── Mission_Master (Master Table)
```

> [!NOTE]
> **Key split:** You **operate** in information pages. You **maintain** in storage/master pages. This separation prevents accidental structural edits during daily use.

---

## Case Study: The Digital Library

All principles above, applied at scale. A complete system from capture to execution to analysis.

<details>
<summary><strong>Full Digital Library architecture (click to expand)</strong></summary>

### Core architecture: 9 modules

1. **Input** — new entries, goals, and missions capture zone
2. **Library Master** — canonical book records (title, author, publisher, pages, category, cover)
3. **Copy Collector** — notable quotes tied to specific books
4. **Search** — fast retrieval layer for titles and quote keywords
5. **Reports** — monthly/yearly performance summaries
6. **Information** — category/author/publisher inventory overviews
7. **Book Gallery** — visual browsing by state
8. **Book Pause** — status management and transitions
9. **Book Calendar** — date-based reading activity tracking

### Status lifecycle in practice

```text
Wishlist → Ready → Reading → Read → Studying → Study Complete → Review Written
```

Each transition corresponds to behavior:

| State | Meaning |
|-------|---------|
| Wishlist | Candidate queue |
| Ready | Selected and prepared |
| Reading | Active consumption |
| Read | Completed once |
| Studying | Extraction/synthesis phase |
| Study Complete | Deep work done |
| Review Written | Output published |

This prevents "I finished but did nothing with it" drift.

### Mission system (daily execution)

The mission layer translates goals into daily action:
- Select a related book
- Record page range read
- Attach date/habit context
- Check input complete → record moves out of Input

Because this uses linked views of the same underlying structures, mission entries are immediately available in progress and report contexts.

### Cross-references

The Copy Collector is related to Library records:
- From a book page → see all collected quotes
- From a quote → jump back to source book and page
- Search can target either title or quote text

This turns isolated highlights into a reusable knowledge graph.

### Reporting

| Metric | Why |
|--------|-----|
| Target books vs completed | Goal tracking |
| Pages read | Volume |
| Reading days | Consistency |
| Attainment rates | Achievement % |
| Distribution metrics (avg, median, variance) | Real behavior patterns |

A single percentage can mislead. You need volume, consistency, and variance signals.

### End-to-end flow

1. Add book to Input (minimal required fields)
2. Complete values → transition to Ready
3. Start reading → log mission progress daily
4. Move to Read when finished
5. Extract quotes in Copy Collector while studying
6. Complete study and write review
7. Inspect monthly report → adjust next month's goal selection

</details>

> [!NOTE]
> **What this case study proves:** The full methodology — one source of truth, many specialized views, dedicated input UX, explicit lifecycle states, strong page structure, and closed-loop reporting. Once you internalize this pattern, you can adapt it to tasks, coursework, research projects, client pipelines, and personal operations.

---

> **Next steps:**
> - [Principles & Anti-Patterns](./principles-and-antipatterns.md) — the rules that prevent this architecture from degrading
> - [Formulas & Automation](./formulas-and-automation.md) — how to make your databases compute and connect automatically
