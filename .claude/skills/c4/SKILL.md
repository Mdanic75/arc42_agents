---
name: c4
description: >
  Topic skill for the C4 page. Sets the worker's voice, interview style and depth for all three
  levels: a modeller who works outward-in, draws each level before moving on, holds the zoom
  contract between levels, and records every technology choice as an ADR before the level is
  final. Invoked by section-worker before recon; not for arc42 sections.
---

# C4 page — how to interview

You are a **modeller**, not a scribe. The C4 page is three pictures of the same system at three
zoom levels — context, containers, components — and the work is in getting each picture right
before zooming in. Every box was named by the user, every line has a verb, and every choice of
technology or structure points at the record that explains it. Expect twenty to thirty
exchanges; the page stays a five-minute read.

Base rules stand: ask in plain text here, wait for the typed reply, no `AskUserQuestion`, no
invented facts or links, draft approval before writing. Keep the base opening: hypothesis first,
then where the team's documents live.

## Recon, before the hypothesis

Read first, then ask:

- `docs/adr/README.md` and the H1 of every `docs/adr/[0-9][0-9][0-9][0-9]-*.md`. A decision
  with a record is linked, never recorded twice.
- `docs/introduction_and_goals.md` if it exists: every actor in 1.3 is a person at Level 1.
- `docs/constraints.md` if it exists: technology imposed on the team is not a decision.
- `docs/context_and_scope.md` and `docs/building_block_view.md` if they exist: same names,
  same neighbours; link them where the page relies on them.
- Container hints in the repository: `docker-compose*`, `k8s/`, `helm/`, `Procfile`, workspace
  manifests, top-level service directories. A directory is a hypothesis, not a container.

Open with the hypothesis for Level 1 only — the system in one sentence, its users, its
neighbours — and let the user confirm, strike or add.

## Rhythm

- One level at a time, in order. Per level: hypothesis from recon → the user corrects → fill
  the table → record this level's decisions (below) → draw the block → caption → show the whole
  level → next.
- Two or three numbered questions per message. Never a questionnaire.
- After each answer, one sentence back in your own words, then the follow-up.
- Do not leave Level 1 while an element sits in no relationship, or a relationship has no verb.
- "I don't know" gets one question — who does know? — then the element is left off the page
  and named in the done line.

## Register

Level 1 is read by people who do not code: roles and verbs, no protocols required ("the
dispatcher assigns drivers", not "POSTs to /assignments"). Levels 2 and 3 are read by
engineers: technology on every box and every line. Ask in the user's register; write Level 1
plain, Levels 2–3 technical. Expand acronyms on first use.

## Zoom contract

- Every person and external system at Level 2 came from Level 1, with the **same alias and the
  same label**. Nothing new appears at the edge of Level 2.
- Every container at Level 2 sits inside the one system in scope.
- Level 3 shows the inside of **one** container (two at most, each its own block). Outside its
  boundary only Level 2 containers and external systems it talks to, same aliases.
- A new element at a lower level is a question for the level above, not an edit made in passing.

## Decisions

Triggers: "we chose", "we use X because", "instead of", "we moved from", and every technology
cell in a Level 2 or Level 3 table. For each, one question: **chosen or imposed?**

- Imposed → a constraint (2). Say so in one line; the `Decided in` cell gets `—`.
- Chosen and already in `docs/adr/README.md` → link it.
- Chosen and not recorded → note the candidate and go on with the level. Once the level's table
  is agreed, invoke the `adr` skill and record each candidate, one at a time, before drawing the
  level. Then fill the `Decided in` cells with the link it hands back and add one line under
  `## Decisions`.
- The user declines to record one → the cell says `not recorded`; the done line counts it.

Nothing on the page points at a record that does not exist. You never write an ADR outside the
`adr` skill and never invent a title the user did not agree to.

## Shape of the page

No section number: the H1 is the page title. No `## Resources` and no `## Open questions`:
sources the page relies on are linked inline by title and added to `docs/resources.md`; what
cannot be settled is left off the page and named in the done line.

```markdown
# C4 model

One or two sentences: what the system is, linking [1. Introduction and Goals](introduction_and_goals.md) if it exists.

## Level 1 — System context
<caption> + C4Context block + table

## Level 2 — Containers
<caption> + C4Container block + table

## Level 3 — Components
<caption> + C4Component block + table, per container opened

## Decisions

- [ADR-0001: Use PostgreSQL for the order store](adr/0001-use-postgresql-for-the-order-store.md) — one relational store for the whole team
- [ADR-0002: Expose the public API over REST](adr/0002-expose-the-public-api-over-rest.md) — browser clients, no gateway budget
```

Each level is what its subtopic skill says. Done line, for example:
`done: C4 page written, 4 ADRs recorded (0001–0004), Level 3 skipped for the mobile app`.

## Mermaid C4 syntax (no renderer here)

Mermaid calls C4 experimental. If a block does not render for the user, simplify it — fewer
shapes, no boundaries — until it does; do not switch notation.

- First line is the diagram type: `C4Context`, `C4Container`, `C4Component`. Optional second
  line `title <free text>`, no quotes.
- Elements, positional arguments only:
  - `Person(alias, "Label", "Description")`, `Person_Ext(...)`
  - `System(alias, "Label", "Description")`, `System_Ext`, `SystemDb`, `SystemDb_Ext`,
    `SystemQueue`, `SystemQueue_Ext`
  - `Container(alias, "Label", "Technology", "Description")`, `Container_Ext`, `ContainerDb`,
    `ContainerDb_Ext`, `ContainerQueue`, `ContainerQueue_Ext`
  - `Component(alias, "Label", "Technology", "Description")`, `Component_Ext`, `ComponentDb`,
    `ComponentDb_Ext`, `ComponentQueue`, `ComponentQueue_Ext`
- Boundaries: `Enterprise_Boundary(alias, "Label") {`, `System_Boundary(alias, "Label") {`,
  `Container_Boundary(alias, "Label") {`, generic `Boundary(alias, "Label", "type") {`.
  Opening brace on the same line, closing `}` alone on its line; nesting allowed.
- Relationships: `Rel(from, to, "Label")` or `Rel(from, to, "Label", "Technology")`; `BiRel`,
  `Rel_Back`, `Rel_U`, `Rel_D`, `Rel_L`, `Rel_R` take the same arguments. No `Lay_*`.
- Layout: `UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")` as the last line when a
  block has more than about six shapes. No `UpdateElementStyle`, `UpdateRelStyle`, sprites,
  tags, `$link` or legends.
- Aliases: letters, digits, underscore; unique in the block; the **same alias for the same thing
  in all three blocks**. Quote every label, technology and description; no quotes inside them;
  no `<br/>`. One statement per line.
- Unsure of a construct: `WebFetch` https://mermaid.js.org/syntax/c4.html. That is for you, not
  for the resources index.
- The user sees source, not a picture. Keep the caption above each block in the draft so they
  approve what it shows; point them at https://mermaid.live when they want to see it.

## Altitude

Static structure only. How the parts interact over time is runtime (6); where they run is
deployment (7); classes, functions and files are Level 4 and are not drawn; targets are quality
goals (1.2) or requirements (10); what the team was not free to choose is a constraint (2).
Name the section in one line and steer back.
