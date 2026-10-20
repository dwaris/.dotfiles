// ============================================================================
// Uni Module Summary / Cheat Sheet Template
// Toggle `cheatsheet: true` for a dense 3-column landscape Formelsammlung.
// ============================================================================

#let module = "Module Name"
#let semester = "WS 2026/27"
#let cheatsheet = false

#set document(title: module)
#set page(
  paper: "a4",
  flipped: cheatsheet,
  columns: if cheatsheet { 3 } else { 1 },
  margin: if cheatsheet { 0.8cm } else { (x: 2cm, y: 2cm) },
  header: if not cheatsheet {
    grid(
      columns: (1fr, 1fr),
      align(left, text(fill: luma(100), size: 9pt, module)),
      align(right, text(fill: luma(100), size: 9pt, semester)),
    )
  },
  numbering: if not cheatsheet { "1 / 1" },
)

#set text(
  size: if cheatsheet { 8pt } else { 10.5pt },
  lang: "de",
)
#set par(justify: true, leading: if cheatsheet { 0.5em } else { 0.65em })
#set heading(numbering: "1.1")
#show raw.where(block: true): set block(
  fill: luma(245),
  inset: 8pt,
  radius: 4pt,
  width: 100%,
)

// Reusable callout box for Definitions, Theorems, or Exam Hints
#let callout(title, color: rgb("#dce0e8"), body) = block(
  fill: color,
  inset: if cheatsheet { 5pt } else { 8pt },
  radius: 4pt,
  width: 100%,
  breakable: true,
  [*#title.* #body],
)

#let defn(title, body) = callout(title, color: rgb("#e6eef8"), body)
#let thm(title, body) = callout(title, color: rgb("#f3e8ff"), body)
#let warn(title, body) = callout(title, color: rgb("#fde8e8"), body)

// Title Block (hidden in cheatsheet mode to save space)
#if not cheatsheet [
  #align(center)[
    #text(size: 18pt, weight: "bold", module) \
    #v(2pt)
    #text(size: 11pt, fill: luma(90), semester)
  ]
  #outline(indent: auto)
  #pagebreak()
]

// ============================================================================
// Content
// ============================================================================

= Lecture 1: Foundations

== Key Concepts

#defn("Vector Space")[
  Let $V$ be a set over a field $FF$. For all $u, v in V$ and $alpha in FF$:
  $ alpha (u + v) = alpha u + alpha v $
]

#thm("Bayes' Theorem")[
  For events $A$ and $B$ with $P(B) > 0$:
  $ P(A | B) = (P(B | A) dot P(A)) / P(B) $
]

#warn("Exam Trap")[
  Always verify whether the matrix $A in RR^(n times n)$ is invertible ($det(A) != 0$) before computing $A^(-1)$.
]

== Algorithms & Code

```python
def binary_search(xs: list[int], target: int) -> int:
    lo, hi = 0, len(xs) - 1
    while lo <= hi:
        mid = (lo + hi) // 2
        if xs[mid] == target:
            return mid
        elif xs[mid] < target:
            lo = mid + 1
        else:
            hi = mid - 1
    return -1
```

== Comparison Table

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  stroke: 0.5pt + luma(180),
  table.header([*Algorithm*], [*Time (Avg)*], [*Space*]),
  [Merge Sort], [$O(n log n)$], [$O(n)$],
  [Quick Sort], [$O(n log n)$], [$O(log n)$],
)
