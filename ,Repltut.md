<!-- Copyright (c) 2026 Tim Menzies, MIT License https://opensource.org/licenses/MIT -->
<a href="https://timm.fyi"><img align="right" alt="Author" src="https://img.shields.io/badge/Author-timm-dc143c?logo=readme&logoColor=white"></a><img align="right" alt="Language" src="https://img.shields.io/badge/Language-Markdown-000080?logo=markdown&logoColor=white"><img align="right" alt="License" src="https://img.shields.io/badge/License-MIT-32cd32?logo=open-source-initiative&logoColor=white"><img align="right" alt="Purpose" src="https://img.shields.io/badge/Purpose-LLM·Authoring·Teaching-7b68ee?logo=githubcopilot&logoColor=white">

### [http://tiny.cc/repltut](http://tiny.cc/repltut)
Prompts and exemplars for generating "genetic stanza" REPL
tutorials: source files that read top-to-bottom as a short paper
and load top-to-bottom as code, narrated by numbered REPL traces
(`[1]>` ... `[48]>`). Includes the authoring prompt, a worked
example (Lisp data mining), and the K&R tone exemplar.

```bash
# install and read
git clone http://tiny.cc/repltut repltut && cd repltut
less author.md
```

<img width="150" align="right" alt="qr" src="https://tiny.cc/tiny/qr-image/tiny.cc~repltut~l~150.png" />

### Files
- [tutgen.md](#file-tutgen-md) — meta-prompt: code in, full multi-lecture REPL course out (harness, audits, weave rules)
- [author.md](#file-author-md) — the authoring prompt (genetic stanza spec, AUTHOR-CONFIG knobs)
- [fri2.md](#file-fri2-md) — worked example: data-lite active learning in SBCL, 48 REPL steps
- [kr_ch1.md](#file-kr_ch1-md) — K&R ch.1 extract; tone calibration for `tone: kr`
- [ezr.tex](#file-ezr-tex) — paper-dialog exemplar; coverage + topic order
- [repl.lua](#file-repl-lua) — reference replay harness (verbatim numbered traces)
- [Makefile](#file-makefile) — konfig knobs (help, push, sh, pdf targets)

## NAME

    repltut - authoring kit for REPL-driven literate tutorials.
    Paste author.md into an LLM (system prompt, CLAUDE.md, or
    lead of a turn); it writes a tutorial like fri2.md.

## SYNOPSIS

    1. Read author.md; fill in its AUTHOR-CONFIG stanza
       (audience, language, depth, tone, repl-density...).
    2. Give the prompt + config + your source code to an LLM.
    3. Out comes a stanza-form tutorial: 65-col prose blocks
       paired with 4-space code blocks, punctuated by numbered
       REPL traces.

## OPTIONS

    AUTHOR-CONFIG knobs (see author.md for full list + defaults):

      audience          one sentence pinning reader background
      assumed           concepts NOT explained
      language          target language + runtime
      depth             terse | standard | verbose
      tone              academic | textbook | conversational | kr
      prose-width       columns of prose            (65)
      stanza-length-cap max code lines per stanza   (10)
      repl-density      stanzas between REPL traces (3)
      repl-prompt       trace prompt string         ([1]>)

## EXEMPLARS

    K&R chapter 1        tone and pacing (kr_ch1.md)
    Lions' Commentary    code-as-paper coverage (cited)
    fri2.md              the stanza + numbered-REPL form
    ezr.tex              coverage, topic order, paper dialog

## OUTPUT

    A single markdown/source file. Each stanza: claim -> code ->
    consequence. Every few stanzas, a runnable REPL trace:

      [12]> (adds (mapcar #'second rows) (make-num))
      #S(NUM :n 398 :mu 23.5 :sd 7.8)

## SEE ALSO

    luamine   http://tiny.cc/luamine  Lua data mining (same CSV protocol)
    konfig    http://tiny.cc/konfig   shared Makefile, dotfiles

## LICENSE

    MIT. https://choosealicense.com/licenses/mit/

## AUTHOR

    Tim Menzies <timm@ieee.org>
