# Citation Protocol — Research Workspace

How to handle citations, evidence, and uncertainty when working in a research workspace.

---

## Core Principles

Research output in this workspace is held to academic standards of correctness, honesty, and reproducibility. These principles apply to all research artifacts — memos, notes, drafts, summaries, and final manuscripts.

- **Every reference must be traceable.** Do not include citations you cannot verify.
- **Uncertainty must be calibrated.** Distinguish between established findings, plausible interpretations, and speculation.
- **Limitations must be declared.** Do not present results beyond what the evidence supports.
- **Sources, versions, and access dates must be specified** for datasets and tools.

---

## Citation Fidelity Rules

### MN-1: Never output an unverifiable citation

Every citation must be resolvable to a real, accessible source. If you cannot confirm that a reference exists and says what you claim, do not cite it.

### MN-2: Never cite a reference not in scope for this work

Every citation must be directly relevant to the current research project or writing task. Do not pad references with loosely related sources.

---

## During Drafting

- Use the `[CITATION NEEDED: description]` marker when you need a reference but do not yet have one confirmed.
- **Never** invent fake citations with author names and years.
- **Never** use `Author et al. (YYYY)` without a matching, verifiable reference.
- If a claim cannot be supported, say so explicitly rather than manufacturing support.

### When a citation gap is found

1. **STOP** further drafting on that claim
2. **FLAG** the exact unsupported claim
3. **Insert** `[CITATION NEEDED: <description of what evidence is needed>]` at the location
4. **Suggest** a concrete evidence-capture step (e.g., "search for a primary source on X", "check if a review paper covers this")
5. **Resume** only after the gap is resolved

---

## Calibrated Uncertainty Language

Use language that accurately represents the strength of the evidence:

| Confidence level | Language to use |
|---|---|
| Well-established, replicated | "X is established", "studies consistently show", "evidence strongly supports" |
| Likely but not certain | "evidence suggests", "it is likely that", "results indicate" |
| Possible but speculative | "it is possible that", "one interpretation is", "this may reflect" |
| Unknown | "it is unclear whether", "data are insufficient to determine", "further study is needed" |

Never collapse a speculative claim into a confident assertion to avoid awkwardness. If you are uncertain, say so.

---

## Integrity Response Protocol

If any integrity issue appears during drafting or review:

1. **STOP immediately**
2. **IDENTIFY** the violation (hallucinated citation, unwarranted certainty, undeclared limitation, non-reproducible method)
3. **FLAG** with quoted text, violation explanation, and missing evidence
4. **SUGGEST** concrete fix steps
5. **RESUME** only after correction

---

## Speculative vs. Final Drafts

- **Speculative drafts** may retain `[CITATION NEEDED]` markers — they signal open questions.
- **Final drafts** must resolve all `[CITATION NEEDED]` markers before delivery. Do not silently remove them; resolve them with evidence or remove the unsupported claim.

### Final drafts MUST NOT

- Contain unresolved `[CITATION NEEDED]` markers
- Silently omit or delete `[CITATION NEEDED]` without resolution
- Hallucinate citations to fill gaps
- Claim readiness for publication without resolving all open evidence gaps

---

## Summary Checklist

Before any research output is delivered:

- [ ] No hallucinated citations
- [ ] All references are traceable to real, accessible sources
- [ ] Calibrated uncertainty language used throughout
- [ ] Data sources, versions, and access dates specified
- [ ] Limitations declared explicitly
- [ ] All `[CITATION NEEDED]` markers either resolved or explicitly retained as open questions in speculative work
