;From quarto-dev/q2
; Structural highlights for the qmd grammar.
;
; Capture names are dotted tree-sitter names under the `markup.*` /
; `punctuation.*` / `attribute.*` roots and ARE the legend entries the
; quarto-lsp-core translator maps through (it prepends a `qmd.` sentinel and
; collapses dotted suffixes by longest-prefix). Emit a distinct name only
; where two constructs need distinct colours.
;
; INVARIANT: never emit a token covering the interior of a code cell
; (`code_fence_content`) or the frontmatter (`metadata`) — those are left to
; the embedded layer (zones 2/3). The `metadata` node is opaque (no child
; nodes for the `---` fences), so the frontmatter delimiters are synthesized
; in the extractor, not matched here.

; --- Headings (ATX only; this grammar has no setext_heading) -----------------
; Capture the whole heading per level; the marker child (narrower) wins
; `punctuation.special` and the remaining text keeps `markup.heading`.
(atx_heading (atx_h1_marker)) @markup.heading.1
(atx_heading (atx_h2_marker)) @markup.heading.2
(atx_heading (atx_h3_marker)) @markup.heading.3
(atx_heading (atx_h4_marker)) @markup.heading.4
(atx_heading (atx_h5_marker)) @markup.heading.5
(atx_heading (atx_h6_marker)) @markup.heading.6

[
  (atx_h1_marker)
  (atx_h2_marker)
  (atx_h3_marker)
  (atx_h4_marker)
  (atx_h5_marker)
  (atx_h6_marker)
] @punctuation.special

; --- Emphasis / strong / strikethrough ---------------------------------------
(pandoc_emph) @markup.emphasis
(pandoc_strong) @markup.strong
(pandoc_strikeout) @markup.strikethrough

[
  (emphasis_delimiter)
  (strong_emphasis_delimiter)
  (strikeout_delimiter)
] @punctuation.special

; --- Inline code span --------------------------------------------------------
(pandoc_code_span (content) @markup.raw.inline)
(code_span_delimiter) @punctuation.special

; --- Links (a pandoc_span is a link only when it has a `target` child) --------
; Bracket punctuation is left uncoloured (default foreground): of `[ ] ( )`
; only `[` and `)` are queryable — the `](` between label and url is one fused
; anonymous token inside `target`, so `]` and `(` cannot be reached by the
; query. Colouring only `[`/`)` made the closing `]` a different colour from
; the opening `[`; uniform default avoids that mismatch (splitting `](` in the
; grammar is out of scope).
(pandoc_span (content) @markup.link.label (target))
(pandoc_span (target (url) @markup.link.url))
(pandoc_span (target (title) @markup.link.title))

; --- Images (reuse `target`; the `![` opener is one fused token) --------------
(pandoc_image "![" @punctuation.special.image)
(pandoc_image (content) @markup.image.label)
(pandoc_image (target (url) @markup.image.url))

; --- Attribute specifiers ({#id .cls key="v"}, and code-cell {r}) -------------
(attribute_specifier) @attribute.specifier

; --- Shortcodes --------------------------------------------------------------
[
  (shortcode)
  (shortcode_escaped)
] @markup.shortcode

; --- Math (leaf tokens; delimiters are not separately exposed) ----------------
[
  (pandoc_math)
  (pandoc_display_math)
] @markup.math

; --- Raw inline/block HTML ---------------------------------------------------
(html_element) @markup.raw

; --- Comments (HTML `<!-- -->` and editorial `[>> ...]`) ---------------------
[
  (comment)
  (edit_comment)
] @markup.comment

; --- Fenced code: delimiter + info string (interior left to zone 3) ----------
(fenced_code_block_delimiter) @punctuation.delimiter.fence
(info_string) @markup.raw.info

; --- Lists and block quotes --------------------------------------------------
[
  (list_marker_plus)
  (list_marker_minus)
  (list_marker_star)
  (list_marker_dot)
  (list_marker_parenthesis)
] @markup.list

(pandoc_horizontal_rule) @punctuation.special

(block_quote_marker) @markup.quote
