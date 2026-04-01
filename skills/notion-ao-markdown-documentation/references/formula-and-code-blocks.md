<!-- Source: notion-page-designer/references/enhanced-markdown-spec.md §Formula & Code Formatting -->
<!-- Extracted during notion-tooling-retirement for markdown-documentation skill -->

## Formula & Code Formatting

### Block Equations (LaTeX)

Block equations use `$$` delimiters on their own lines:

```markdown
$$
\frac{\partial \rho}{\partial t} + \nabla \cdot (\rho \mathbf{u}) = 0
$$
```

The KaTeX engine supports standard LaTeX math commands. Multi-line equations use `\\` for line breaks inside the block:

```markdown
$$
\begin{aligned}
\nabla \times \mathbf{E} &= -\frac{\partial \mathbf{B}}{\partial t} \\
\nabla \times \mathbf{B} &= \mu_0 \mathbf{J} + \mu_0 \varepsilon_0 \frac{\partial \mathbf{E}}{\partial t}
\end{aligned}
$$
```

Scientific forward operator example (advection):

```markdown
$$
\mathcal{M}_{t_i \to t_{i+1}}(\mathbf{x}_i) = \mathbf{x}_i + \int_{t_i}^{t_{i+1}} f(\mathbf{x}(\tau), \tau)\, d\tau
$$
```

### Inline Equations

```markdown
The ensemble mean is $\bar{\mathbf{x}} = \frac{1}{N}\sum_{i=1}^{N} \mathbf{x}_i$.
```

### Code Blocks with Language Tags

````markdown
```fortran
program hello
  implicit none
  write(*,*) 'Hello, World!'
end program hello
```
````

````markdown
```sql
SELECT e.name, COUNT(o.id) AS order_count
FROM employees e
LEFT JOIN orders o ON e.id = o.employee_id
GROUP BY e.name
HAVING COUNT(o.id) > 5;
```
````

### Anti-Pattern Table

| ❌ Anti-pattern | Why it fails | ✅ Fix |
|---|---|---|
| `` `E = mc^2` `` (inline code for equation) | Monospace rendering, no math symbols | `$E = mc^2$` (inline math) |
| `E = mc²` (Unicode superscript) | Not rendered as math; breaks in complex expressions | `$E = mc^2$` |
| `$$E=mc^2$$` on a single line with other text | Ambiguous parsing; may render inline | Put `$$` on its own lines |
| Language tag `math` in code block | Not a valid Notion language; renders as plain text | Use `$$...$$` equation block |
| Mixing LaTeX and Unicode in same expression | Inconsistent rendering | Use pure LaTeX inside `$...$` |
