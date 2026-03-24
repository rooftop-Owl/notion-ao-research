# Two-Zone Model — Research Workspace Architecture

The research workspace uses a deliberate two-layer architecture. Understanding this model prevents misuse and clarifies why no automation bridges the layers.

---

## Overview

The Two-Zone Model separates **automated ingestion** (Layer 1) from **curated structured knowledge** (Layer 2). Content enters Layer 1 automatically via agent commands; it reaches Layer 2 only through deliberate human curation. The gap between layers is **intentional** — it is a design decision, not a missing feature.

```
Capture URL ──► Ingestion DB (Layer 1, automated ingestion)
                 │
                 │  [deliberate curation gap — intentional, NOT a bug]
                 ▼
          Structured DB (Layer 2, human-curated, relational, annotated)
```

This separation ensures Layer 2 remains a high-quality, annotated workspace rather than a noisy dump of every URL ever captured.

---

## Layer 1 — Ingestion (Automated)

Layer 1 databases are **active ingestion targets**. They are NOT deprecated.

| Database | Populated by | Purpose |
|---|---|---|
| Ingestion databases | Feed/capture commands | URL captures, articles, repos, tools, synthesized intelligence |

**Characteristics of Layer 1:**
- Write-once: content is created, not curated
- Minimal schema: URL, type, status, tags, ingestion date
- High volume: every feed/capture call lands here
- No relations to Layer 2 databases (by design)

Layer 1 is the **fast capture** layer. Speed and automation are its purpose.

---

## Layer 2 — Structured Workspace (Curated)

Layer 2 databases form the **academic knowledge graph**. Every entry here was placed deliberately.

| Database | Role |
|---|---|
| Literature | Papers, articles with DOI, abstract, project links |
| Projects | Active research projects with milestones and experiments |
| Experiments | Experiment designs, methods, results |
| Notes | Analysis memos, research questions, meeting notes |
| Writing Pipeline | Manuscripts at each stage of the writing process |
| Milestones | Project milestones with due dates and status |

**Characteristics of Layer 2:**
- Richer schema: DOI, abstract, authors, relations, experiment links, project links
- Relational: entries link to each other across databases
- Annotated: summaries, findings, and handoff context are expected
- Academic papers may arrive here **directly via a Zotero bridge** — bypassing ingestion databases entirely

Layer 2 is the **curated knowledge** layer. Quality and structure are its purpose.

---

## Promotion Checklist — When to Move Layer 1 → Layer 2

Promotion is always **manual**. Consider promoting an ingestion entry to a Layer 2 literature record when:

- **Referenced in ≥1 digest** — the item has been synthesized and deemed worth tracking
- **Used or cited in the writing pipeline** — the item appears in a manuscript's reference list
- **Has a DOI or clear academic attribution** — if so, prefer using a Zotero bridge directly rather than promoting from ingestion
- **Directly relevant to an active research project** — the item informs current experimental or analytical work

**Promotion steps:**
1. Open the ingestion database page in Notion
2. Create a new Layer 2 literature entry manually with full metadata (title, authors, DOI, abstract, year, venue)
3. Set project and citation relations to link the entry into the knowledge graph
4. Optionally archive or tag the original ingestion entry as promoted

There is no automated promotion path. This is intentional (see next section).

---

## Why the Gap Is Intentional

Three reasons the Layer 1 → Layer 2 gap is a design decision, not a missing feature:

**1. Curation quality**
Layer 2 entries require deliberate annotation: abstract, DOI, project links, experiment links. Auto-promotion would produce entries with empty fields and no relational context — defeating the purpose of Layer 2.

**2. Prevents noise**
Every feed URL landing in Layer 2 would pollute the structured workspace with unreviewed content. The ingestion database absorbs this volume intentionally so Layer 2 stays clean.

**3. Separation of concerns**
Layer 1 = fast capture (speed matters, quality is secondary).
Layer 2 = curated knowledge (quality matters, speed is secondary).
Mixing these concerns degrades both layers.

**Do not automate promotion.** If you find yourself writing a script to bulk-promote ingestion entries, you are working against the architecture.

---

## Database Quick Reference

| Layer | Database | Role |
|---|---|---|
| Layer 1 | Ingestion databases | URL captures, synthesized intelligence |
| Layer 2 | Literature | Curated papers and articles |
| Layer 2 | Projects | Active research projects |
| Layer 2 | Experiments | Experiment designs and results |
| Layer 2 | Notes | Analysis memos and research questions |
| Layer 2 | Writing Pipeline | Manuscripts at each writing stage |
| Layer 2 | Milestones | Project milestones and deadlines |
