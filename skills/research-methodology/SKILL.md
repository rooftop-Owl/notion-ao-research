---
name: research-methodology
description: >-
  This skill should be used when working on any research task, when the user asks
  about "research methodology", "citation standards", "Two-Zone Model", "research
  integrity", "citation needed markers", or "calibrated uncertainty". Provides
  foundational principles for conducting rigorous research with non-negotiable
  citation fidelity rules.
license: CC-BY-NC-SA-4.0
metadata:
  author: https://github.com/rooftop-Owl
  version: "1.1.0"
  domain: research
  triggers: research methodology, citation standards, Two-Zone Model, research integrity, citation needed, calibrated uncertainty, evidence quality
  role: specialist
  scope: methodology
  output-format: guidelines
  related-skills: writing-conventions, project-context, notion-research
---

# Research Methodology

## Overview

The research workspace operates on the **Two-Zone Model** — a deliberate two-layer architecture that separates automated ingestion from curated structured knowledge. Layer 1 (ingestion) captures content automatically at high volume. Layer 2 (structured workspace) holds only deliberate, human-curated entries. The gap between them is **intentional by design**, not a missing feature.

See `references/two-zone-model.md` for the full diagram, promotion checklist, and database quick reference.

## Core Rules

### Never automate the Layer 1 → Layer 2 promotion step

Promotion is **always manual and deliberate**. Do not write scripts to bulk-promote Layer 1 entries into Layer 2 databases. When you find yourself automating this step, you are working against the architecture.

The Layer 1 databases (ingestion databases) are write-once, high-volume, minimal-schema targets. The Layer 2 databases (your structured workspace databases) are the curated knowledge graph — relational, annotated, and high-quality.

### Citation integrity is non-negotiable

Every reference you include in research output must be traceable to a real source. Follow these rules at all times:

- **Never hallucinate citations.** Do not invent author names, years, titles, or DOIs.
- **Never use `Author et al. (YYYY)` without a verifiable, linked source.**
- **If a reference cannot be confirmed**, use the marker `[CITATION NEEDED: description of what is needed]` instead of inventing a reference.
- **Use calibrated uncertainty language.** Distinguish between established findings, likely interpretations, and speculation. Use "evidence suggests", "it is likely", "it is unclear whether" as appropriate.
- **Specify data sources, versions, and access dates** when citing datasets or tools.
- **Declare limitations explicitly.** Do not present results beyond what the evidence supports.

### When uncertain, flag — never fill the gap with invention

When you lack a citation or cannot confirm a claim:

1. Insert `[CITATION NEEDED: <description>]` at the exact location
2. Flag the unsupported claim explicitly in any output or summary
3. Suggest a concrete evidence-capture step (e.g., "this should be confirmed by reviewing [source type]")
4. Do NOT resume as though the gap were closed until it is actually resolved

Speculative drafts may retain `[CITATION NEEDED]` markers. Final drafts must resolve all markers before delivery.

## Research Integrity Principles

- **Reproducibility**: Provide methods, parameters, and tool versions sufficient for another researcher to reproduce your process.
- **Honesty about scope**: If a claim goes beyond the available evidence, say so.
- **Source attribution**: Every artifact that enters Layer 2 must carry its origin (DOI, URL, Zotero key, or equivalent).
- **No silent omissions**: If you drop a `[CITATION NEEDED]` marker without resolving it, you are misrepresenting the quality of the output.

## References

- `references/two-zone-model.md` — Full Two-Zone Model: architecture diagram, promotion checklist, DB quick reference, rationale
- `references/citation-protocol.md` — Citation fidelity rules, calibrated uncertainty language, integrity response protocol
