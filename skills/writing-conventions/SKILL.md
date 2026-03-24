---
name: writing-conventions
description: >-
  This skill should be used when the user asks for help with any writing task —
  "academic paper", "literature review", "research notes", "documentation",
  "calibrated language", "citation quality", "writing style". Provides writing
  standards, calibrated uncertainty language, citation quality gates, and
  consistency rules for research output.
license: CC-BY-NC-SA-4.0
metadata:
  author: https://github.com/rooftop-Owl
  version: "1.1.0"
  domain: research
  triggers: academic writing, literature review, research notes, calibrated language, citation quality, writing style, uncertainty language, document quality
  role: specialist
  scope: writing
  output-format: guidelines
  related-skills: research-methodology, notion-research
---

# Writing Conventions

## Calibrated Uncertainty Language

Use hedged language when evidence is incomplete: "suggests", "may", "is consistent with", "appears to".

Use confident language only when evidence is strong: "demonstrates", "shows", "establishes", "proves".

Never use "clearly" or "obviously" — these hide reasoning and signal unjustified confidence.

Explicitly state confidence level when relevant: "With high confidence: X. More speculatively: Y."

Match language precision to evidence quality — weaker data warrants weaker verbs.

## Citation Standards

Every factual claim needs a traceable source.

When a source is unavailable, insert `[CITATION NEEDED: description of the claim]` — never invent citations.

Never fabricate author names, years, or journal titles to fill a citation gap.

Distinguish explicitly between: (1) established findings from the literature, (2) your own analysis, (3) speculation or inference.

Declare data sources, versions, and access dates when citing datasets, software, or online tools.

## Consistency Rule

Before reversing a prior stance or contradicting an earlier statement, re-verify the original evidence.

Treat a reader's challenge as a prompt to re-check, not a signal to capitulate — pressure is not evidence.

If new evidence genuinely contradicts prior conclusions, acknowledge the reversal explicitly: "Upon re-examination, the earlier conclusion was X. New evidence suggests Y instead."

Do NOT silently change positions between sections, versions, or responses — surface the reasoning and the trigger.

Document what changed and why when a conclusion is revised.

## Document Quality Gates

Final documents must have zero `[CITATION NEEDED]` markers — resolve or remove speculative claims before finalizing.

Speculative drafts (`.speculative.md`) may retain markers; final `.md` files must be clean.

A Limitations section is mandatory in all research outputs — explicitly state what the analysis does NOT cover, what data was excluded, and where the methodology could break down.

Do not claim a draft is final without verifying all markers are resolved and all citations are traceable.

Do not silently remove `[CITATION NEEDED]` markers — either supply the evidence or remove the unsupported claim.

## Writing Style

Prefer active voice and precise verbs over vague nominalizations ("the model predicts" not "predictions are made by the model").

Define acronyms on first use: "Coupled Model Intercomparison Project (CMIP6)".

Provide enough methodological detail that another researcher could replicate the work — include tool versions, parameters, and random seeds where applicable.

Keep sentence structure parallel within lists and headings.

Use consistent terminology throughout: choose one term per concept and do not alternate synonyms.

Quantify uncertainty when possible: provide confidence intervals, error bars, or sensitivity ranges rather than qualitative hedges alone.
