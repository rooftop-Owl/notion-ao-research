---
name: notion-ao-markdown-documentation
description: >-
  This skill should be used when writing markdown docs, READMEs, or formatting any
  GFM content. Covers GitHub Flavored Markdown syntax, callouts/alerts, collapsible
  sections, Mermaid diagrams, LaTeX formulas and code blocks (including
  Notion-flavored variants), tables, links, and text formatting patterns. Load when
  producing or reviewing any markdown-formatted document.
license: MIT
metadata:
  author: https://github.com/aj-geddes/useful-ai-prompts
  version: "1.3.0"
  domain: documentation
  triggers: write markdown, format docs, README, GitHub Flavored Markdown, GFM, mermaid diagram, LaTeX formula, code block, callout, alert, table formatting, collapsible section
  role: reference
  scope: formatting
  output-format: formatted-text
  related-skills: notion-ao-writing-conventions
---

# Markdown Documentation

## Table of Contents

- [Overview](#overview)
- [When to Use](#when-to-use)
- [Quick Start](#quick-start)
- [Reference Guides](#reference-guides)
- [Best Practices](#best-practices)

## Overview

Master markdown syntax and best practices for creating well-formatted, readable documentation using standard Markdown and GitHub Flavored Markdown (GFM).

## When to Use

- README files
- Documentation pages
- GitHub/GitLab wikis
- Blog posts
- Technical writing
- Project documentation
- Comment formatting

## Quick Start

- Comment formatting

```markdown
# H1 Header

## H2 Header

### H3 Header

#### H4 Header

##### H5 Header

###### H6 Header

# Alternative H1

## Alternative H2
```

## Reference Guides

Detailed implementations in the `references/` directory:

| Guide | Contents |
|---|---|
| [Text Formatting](references/text-formatting.md) | Text Formatting |
| [Lists](references/lists.md) | Lists |
| [Links and Images](references/links-and-images.md) | Links and Images, Code Blocks, Tables |
| [Extended Syntax (GitHub Flavored Markdown)](references/extended-syntax-github-flavored-markdown.md) | Extended Syntax (GitHub Flavored Markdown) |
| [Collapsible Sections](references/collapsible-sections.md) | Collapsible Sections, Syntax Highlighting, Badges |
| [Alerts and Callouts](references/alerts-and-callouts.md) | Alerts and Callouts |
| [Mermaid Diagrams](references/mermaid-diagrams.md) | Mermaid Diagrams |

## Additional Resources

- `references/formula-and-code-blocks.md` — LaTeX block/inline equations (KaTeX), language-tagged code blocks, anti-pattern table

## Best Practices

### ✅ DO

- Use descriptive link text
- Include table of contents for long documents
- Add alt text to images
- Use code blocks with language specification
- Keep lines under 80-100 characters
- Use relative links for internal docs
- Add badges for build status, coverage, etc.
- Include examples and screenshots
- Use semantic line breaks
- Test all links regularly

### ❌ DON'T

- Use "click here" as link text
- Forget alt text on images
- Mix HTML and Markdown unnecessarily
- Use absolute paths for local files
- Create walls of text without breaks
- Skip language specification in code blocks
- Use images for text content (accessibility)
