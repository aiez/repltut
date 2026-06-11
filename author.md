# Authoring Prompt: Genetic Stanza Literate Source

> Paste the section below as a system prompt, project CLAUDE.md, or the
> lead of a turn. It instructs an author (human or model) to produce a
> single source file that reads top-to-bottom as a paper and loads
> top-to-bottom as code. Language-agnostic; the AUTHOR-CONFIG stanza
> picks the target.

## The Prompt


    You are authoring a source file in "genetic stanza" style.
    The file must (a) load cleanly into the target language and
    (b) read top-to-bottom as a short paper.

    # CONFIG

    Open the file with an AUTHOR-CONFIG stanza declaring the knobs
    below. Every later decision (depth, tone, where the tutorial
    sits, naming) refers back to this block. Defaults in brackets.

    Required:
    - audience: one sentence pinning reader background
      (e.g. "Python dev, no Lisp")
    - assumed: comma list of concepts NOT explained
      (e.g. "recursion, OO basics, stats")
    - language: target language + dialect/runtime
      (e.g. "Common Lisp (CLISP)")
    - depth: terse | standard | verbose [standard]
    - tutorial-placement: front | back | jit | none [back]
    - target: source-only | latex | html | dual | markdown [source-only]

    Optional (override defaults):
    - prose-width: integer [65]
    - code-indent: integer spaces [4]
    - comment-delim: lang-specific [#| |# for Lisp]
    - naming-prefix: example function prefix [eg--]
    - justification-delay: uses before why [2]
    - stanza-length-cap: max code lines per stanza [10]
    - tone: academic | textbook | conversational [textbook]
    - voice: first | third | imperative [third]
    - example-autorun: yes | no [yes]
    - cross-links: on | off [on]
    - domain: field jargon allowed without gloss [none]
    - repl-density: stanzas between REPL traces [3]
    - repl-prompt: prompt string used in traces [`[1]>`]

    Example config stanza:

        #| AUTHOR-CONFIG
        audience: Python dev, new to Lisp
        assumed: recursion, OO basics, stats
        language: Common Lisp (CLISP target)
        depth: standard
        tutorial-placement: back
        target: dual
        naming-prefix: eg--
        tone: textbook
        voice: third
        |#

    The config governs the audit. "Did the file match its config?"
    is the audit question, not "did this feel right?"

    # FORM

    A *stanza* is one prose block followed by one code block.

    - Prose lives inside `#| ... |#` block comments.
    - Delimiters HUG the text. No bare `#|` or `|#` line.
      Bad:
          #|
          Num tracks ...
          |#
      Good:
          #| Num tracks running mean and second moment.
          Derived sd via Welford. |#
    - Prose wraps at 65 columns max.
    - Code indents 4 spaces from column 0.
    - One concept per stanza. Stanza fits on one screen with prose.

    # ORDER (the "genetic" part)

    Concepts appear in build order. Reader recapitulates discovery.

    1. Atoms first (leaf data structures).
    2. Sibling atoms paired before either is used (e.g. Num then Sym,
       then operations over them).
    3. Operations over atoms after the atoms exist.
    4. Containers after the things they contain.
    5. Factories after their products.
    6. Call sites last, as payoff.

    Never reference a name before it is defined in the file.

    # BEATS

    Each stanza follows: claim → code → consequence.
    Drop the consequence beat when the code makes it self-evident.

    # COMMENT BUDGET

    - Spend prose on the non-obvious: design choices, conventions,
      surprises, invariants.
    - Skip the obvious. Do not gloss `(setf (foo-x f) x)`.
    - Name moving parts inline so the reader's eye jumps
      prose ↔ code via shared tokens (mu, sd, has, heaven).
    - Prefer short names that survive both contexts.

    # DEFERRED RATIONALE

    Show a pattern twice before justifying it. Reader sees the shape,
    then gets the why. Example: introduce two functions that dispatch
    on type, *then* explain why functions over methods.

    # SIBLING PAIRING

    When two concepts mirror each other (Num/Sym, mid/spread,
    mu/mode, sd/entropy), present them adjacently with parallel
    prose structure. Symmetry is a teaching tool; expose it.

    # NAMING

    - Source is lowercase. CL reader uppercases by default.
    - Examples are `(defun eg--name () ...)` with a docstring.
    - Each example is self-contained and runnable from the REPL.

    # EXAMPLES APPENDIX

    End the file with an examples section. One `defun eg--N` per
    concept introduced in the body. Each example:
    - has a docstring summarising what it demonstrates;
    - sets up its own state (no shared globals);
    - prints or returns a value the reader can verify.

    Close with an auto-runner:

        (defun eg--all ()
          (do-symbols (s *package*)
            (when (and (fboundp s)
                       (search "EG--" (symbol-name s))
                       (not (eq s 'eg--all)))
              (format t "~%--- ~a ---~%" s)
              (funcall s))))

    # TUTORIAL APPENDIX

    Unless config says `tutorial-placement: none`, end the file with
    a short language tutorial. Rules:

    - Scope: cover only language features the body actually uses.
      No primer for unused constructs.
    - Form: same stanza rules. Prose ≤ 65 cols, code indented 4.
    - Examples: lifted from the body, not invented toys. Each entry
      cites the body stanza where the construct first appears.
    - Audience-driven: write for the reader pinned in CONFIG. Skip
      what `assumed:` lists. Cover what `assumed:` does not.
    - Cross-link: each tutorial entry ↔ first body use.
    - Two-pass audit (run before delivery):
      1. Coverage. Walk every code construct in body. Each one
         appears in tutorial OR in `assumed:`. No exceptions.
      2. Necessity. Walk every tutorial entry. Each one appears in
         body. Cut entries with no referent.
    - Audit output: a diff list (entries to add, entries to cut),
      not a vibe.

    Per-language confusion checklist (Common Lisp shown; adapt for
    other languages):

    - quote vs function-quote: `'x` vs `#'x`
    - nil = empty list AND false
    - `let` double-paren binding: `((x 1) (y 2))`
    - `setf` as generalised place setter
    - lambda lists: `&optional`, `&key`, `&rest`
    - multiple-value return: `values`, `multiple-value-bind`
    - reader macros: `#|`, `#(`, `#\`
    - package qualifiers: `pkg:sym` vs `pkg::sym`
    - `loop` macro mini-DSL
    - `cons` vs `list` vs `append`
    - macro vs function (eval timing)

    Audit fails if body uses any item above and tutorial omits it.

    # OUTPUT INVARIANTS

    Before delivering, verify:

    1. File loads in the target language with no errors.
    2. AUTHOR-CONFIG stanza is present and complete.
    3. Every later choice (depth, tone, placement) matches CONFIG.
    4. Each stanza fits on one screen (prose + code together).
    5. Every identifier mentioned in prose appears in nearby code.
    6. No identifier is used before it is defined.
    7. Every non-obvious design choice has a one-sentence rationale
       within a few stanzas of where it appears.
    8. Sibling concepts are paired, not separated.
    9. Width: prose ≤ `prose-width`, code indented `code-indent`.
    10. `eg--*` appendix covers every concept introduced.
    11. Tutorial appendix passes coverage + necessity audit.

    # WHAT NOT TO DO

    - Do not write top-down stepwise refinement. That is Knuth/Wirth
      style; this is the inverse.
    - Do not use docstrings as a substitute for stanza prose. The
      prose lives in `#| |#` blocks above the code.
    - Do not split a class/struct definition across stanzas.
    - Do not add commentary inside code (`;` line comments) except
      for one-token reminders. The block comments carry the prose.
    - Do not paste a whole file then narrate it. One stanza at a
      time, in build order.

    # MARKDOWN TARGET

    When `target: markdown`, the source file is .md (no host
    language wrapping). Differences from the source-only target:

    - DROP all `#| ... |#` block comments. Prose is plain
      markdown, not embedded in comments.
    - DROP the "file must load as code" invariant. The .md is
      read, not loaded. Code blocks are illustrative.
    - USE markdown headings: `#` for the file title, `##` for
      parts (Atoms, Containers, Distance, Trees, Active,
      Examples, Tutorial), `###` for individual stanzas
      (one heading per concept).
    - USE fenced code blocks (```` ``` ````) instead of 4-space
      indent. Tag the fence with the language: ```` ```lisp ````.
    - USE inline `code` markup for identifiers in prose.
    - KEEP prose-width, sibling pairing, build order,
      deferred rationale, examples appendix, tutorial appendix.
    - KEEP one-concept-per-stanza discipline; each `###`
      heading scopes one stanza.

    ## Menu bar (top-of-file table of contents)

    Open the file (after `# Title`) with a navigation menu in
    sexp-style nesting: parens group sections, links sit
    inline. Each row ends in TWO trailing spaces so markdown
    renders a hard line break between rows.

    Form:

        (group1 [a](#a) [b](#b))··
        (group2 (sub1 [c](#c) [d](#d)) [e](#e))··

    (`··` indicates the two trailing spaces; do
    not type literal middots.) Anchors are markdown-auto-slugs
    of `###` headings (lowercase, spaces → hyphens, punctuation
    stripped). Verify each link resolves.

    ## REPL trace density

    Sprinkle interactive REPL traces throughout the body; per
    `repl-density` (default: every 3 stanzas), insert a fenced
    block showing the named functions in action. Trace form:

        ```
        [1]> (make-num :txt "Mpg+")
        #S(NUM :TXT "Mpg+" :HEAVEN 1 ...)
        [2]> (add * 23)
        23
        ```

    Rules:
    - Trace builds on prior bindings (`*` = last value).
    - Output lines show realistic results, not placeholders.
    - Each trace exercises the stanza it follows.
    - Audit: every named function in the body appears in at
      least one trace.

    # DELIVERABLE

    A single source file in the target language. No companion
    markdown. The same file is both the program and the paper. A
    small awk script can later flip block comments to LaTeX/HTML
    for typesetting; the source is canonical.

## Author Config Variables

Knobs declared at the top of every file in an `AUTHOR-CONFIG` stanza.
Required vars pin the audience and language; optional vars override
style defaults. Audit asks "did the file match its config?" — without
config, every later judgement floats.

### Required

- **audience** — one sentence on assumed reader background.
- **assumed** — comma list of concepts NOT explained.
- **language** — target language plus dialect/runtime.
- **depth** — terse \| standard \| verbose.
- **tutorial-placement** — front \| back \| jit \| none.
- **target** — source-only \| latex \| html \| dual.

### Optional (with defaults)

- **prose-width** \[65\]
- **code-indent** \[4\]
- **comment-delim** \[`#| |#` for Lisp\]
- **naming-prefix** \[`eg--`\]
- **justification-delay** \[2 uses before why\]
- **stanza-length-cap** \[10 code lines\]
- **tone** \[textbook\]
- **voice** \[third-person\]
- **example-autorun** \[yes\]
- **cross-links** \[on\]
- **domain** \[none — no field jargon assumed\]

## Tutorial Appendix Rules

Drives the language primer at the back of the file (or front, or inline,
per `tutorial-placement`).

- **Scope.** Covers only constructs the body uses. No unused-feature
  primer.
- **Form.** Same stanza rules: prose width, indent, hugging delimiters.
- **Examples.** Lifted from body, not invented. Each cites the body
  stanza where the construct first appears.
- **Audience-aware.** Skip what `assumed:` lists. Cover what it does
  not.
- **Cross-linked.** Tutorial entry ↔ first body use, both directions.
- **Two-pass audit.**
  1.  *Coverage*: every body construct → either in tutorial or in
      `assumed:`.
  2.  *Necessity*: every tutorial entry → appears in body. Cut dead
      entries.

  Output is a diff (add/cut list), not a verdict.
- **Re-audit trigger.** Body grows a new construct → audit re-runs.

## Reference Stanza


    #| Num tracks a running mean (mu) and second moment (m2).
    Standard deviation sd is derived from m2 via Welford. The
    heaven flag records goal direction: 0 if name ends "+",
    else 1. |#

        (defstruct num
          (txt "") (at 0) (n 0)
          (mu 0) (m2 0) (sd 0) heaven)

    #| Sym counts symbol frequencies in a HAS hashtable. Mode is
    arg max of HAS; entropy is -sum(p log p). |#

        (defstruct sym
          (txt "") (at 0) (n 0)
          (has (make-hash-table :test #'equal)))

## Naming the Style

**Genetic stanza.** *Genetic* from Lakatos/Pólya: present concepts in
the order they could be discovered. *Stanza* for the fixed couplet form:
65-col prose paired with 4-space code. Form name says how it looks;
content name says why that order.
