---
name: notion-ao-project-context
description: >-
  This skill should be used when the user asks about "project context", "current
  priorities", "what are we working on", "active decisions", "recent handoffs",
  or "sync context". Fetches the project hub Notion page to surface current
  project state before starting any research task.
license: CC-BY-NC-SA-4.0
metadata:
  author: https://github.com/rooftop-Owl
  version: "1.3.0"
  domain: research
  triggers: project context, current priorities, what are we working on, active decisions, recent handoffs, sync context, session start
  role: specialist
  scope: context
  output-format: summary
  related-skills: notion-ao-ops, notion-ao-research-methodology
---

# Project Context Skill

## Purpose

Before starting any research task, surface the current project state by fetching the Project Hub Notion page. This ensures all research is grounded in active priorities, respects established constraints, and continues from where the last session left off.

---

## Step 0 — Resolve the Project Hub Page ID

The Project Hub page ID is workspace-specific. Resolve it from your workspace configuration:

1. Read `NOTION_WORKSPACE.md` (or equivalent workspace config file)
2. Find the **Project Pages** section
3. Extract the Project Hub page ID (format: `<PROJECT_HUB_PAGE_ID>`)

If no workspace config exists, ask the user for the Project Hub page ID before proceeding.

---

## Step 1 — Fetch the Project Hub Page

Use `notion-fetch` with the resolved Project Hub page ID:

```
notion-fetch(id="<PROJECT_HUB_PAGE_ID>")
```

---

## Step 2 — Read Each Section

The Project Hub has five sections. Read each one carefully:

**`## Active Decisions`**
Architectural and methodology choices already made. Do not re-open these unless new evidence explicitly warrants revisiting them. Treat them as settled context, not open questions.

**`## Current Priorities`**
What to focus on right now. If a task the user is asking about is not listed here, check with the user before pursuing it — it may be out of scope or deprioritized.

**`## Constraints`**
Non-negotiable rules that apply to all research output. Always apply these. They cover things like data sources, methodology boundaries, and output format requirements.

**`## Latest Handoffs`**
Links to session handoff entries in your research databases. Read the most recent handoff to understand where the previous session left off — what was completed, what is in progress, and what is blocked.

**`## Quick Reference`**
Links to your research databases (Literature, Projects, Experiments, Notes, Writing Pipeline, Milestones). Use these for navigation when you need to query or update a specific database.

---

## Step 3 — Summarize Before Proceeding

After reading the page, briefly summarize what you found:

- What are the current priorities?
- Are there any active blockers?
- What did the most recent handoff say?

Then proceed with the research task using this context as the frame. Do not skip the summary — it anchors the session.

---

## When the Page Is Empty or Stale

If the Project Hub page is empty or its sections contain no content:

- Note that the page is empty and proceed without blocking the user.
- Suggest the user run `/sync-context` to refresh the page with current project state.
- Continue with the research task using whatever context is available from the conversation.
