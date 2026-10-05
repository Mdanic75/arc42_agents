---
name: brief
description: The arc42 section briefs and skill map — Cover, Altitude and the Skills line for the twelve sections and the C4 page. Invoked by the orchestrator once per session before the first spawn, to quote a section's paragraph into the worker's spawn prompt; the worker invokes it only when its spawn prompt carries no Brief.
---

# arc42 section briefs

Invoked by the orchestrator once per session, which quotes a section's paragraph to
`section-worker` at spawn: find your section, cover what its *Cover* lists, in order, and stay at
its *Altitude* — what the note must not descend into. This is not an arc42 section. It ships with
the `arc42` plugin as the `brief` skill (`skills/brief/SKILL.md`); a project that wants to tailor
it copies the body below the frontmatter to `docs/arc42_sections.md`, which the orchestrator
prefers when present.

Every note: H1 `# <N>. <Section>`, subsections `## <N>.1 …`, `## <N>.2 …`. Pages outside arc42
(at the end of this file) are unnumbered: H1 is the page title, teammate name is the slug.

Each brief ends with a `Skills:` line — its topic skill and subtopic skills, files at
`skills/<name>/SKILL.md` in the arc42_agents repository, loaded as the `arc42` plugin so the
names appear as `arc42:<name>`. The orchestrator passes the bare names to the worker; the worker
invokes the topic skill before the interview and each subtopic skill when it reaches that
subsection. A skill wins over the brief; the brief is the fallback when a skill is missing. Add a
name here to have the orchestrator pass it.

The `adr` skill is not listed per section: every worker invokes it when a decision surfaces and
records the decision in `docs/adr/` (index `docs/adr/README.md`).

**1 — Introduction and Goals.** Cover: 1.1 Requirements overview — what the system does, for
whom, the handful of features without which it is pointless, what drove someone to build it; one
paragraph and a short list, not a specification. 1.2 Quality goals — the top three to five,
ranked, each with a one-line scenario that makes it testable ("a page of results returns in under
300 ms with 50 concurrent users", not "fast"); offer the ISO 25010 categories as a menu when the
user stalls (performance efficiency, security, reliability, usability, maintainability,
compatibility, portability, functional suitability); push back on "fast, secure and reliable" and
force the ranking, because the ranking is what informs design decisions; more than five means
nothing is prioritised. 1.3 Stakeholders — role and expectation, three to eight rows; "everyone"
is not a stakeholder. Altitude: a two-minute read. No mechanisms, components, interfaces,
technology choices, data models or deployment.

Skills: topic `introduction-and-goals`; subtopics `requirements-overview`, `quality-goals`, `stakeholders`.

**2 — Constraints.** Cover: technical constraints, organizational constraints, conventions —
each a table row with a one-line rationale. Altitude: only things the team is *not free to
decide*. A choice the team made is a decision (9), not a constraint.

Skills: topic `constraints`; subtopics `technical-constraints`, `organizational-constraints`, `conventions`.

**3 — Context and Scope.** Cover: 3.1 Business context — users and neighbouring systems, and
what data crosses each boundary. 3.2 Technical context — channels and protocols, and which
business input or output rides on which channel. Altitude: the boundary and its neighbours.
Nothing about the inside. If `docs/c4.md` exists, link its Level 1 by title instead of redrawing.

Skills: topic `context-and-scope`; subtopics `business-context`, `technical-context`.

**4 — Solution Strategy.** Cover: the key technology decisions, the top-level decomposition, the
approach taken to each quality goal from 1.2, organizational decisions that shape the
architecture. Altitude: a short paragraph or a few bullets per item, each pointing to where
sections 5–9 elaborate.

Skills: topic `solution-strategy`; no subtopic skills.

**5 — Building Block View.** Cover: level 1, a whitebox of the whole system — its blackboxes,
each with name, responsibility and interfaces. Deeper levels only where the user wants them.
Altitude: static structure only. Behaviour belongs to 6, infrastructure to 7. If `docs/c4.md`
exists, its Levels 2–3 are the whitebox: link, do not redraw.

Skills: topic `building-block-view`; subtopics `whitebox-overall-system`, `building-block-level-2`, `building-block-level-3`.

**6 — Runtime View.** Cover: a few key scenarios — the main use cases, startup, an error path,
the quality-critical one — as numbered step lists naming the building blocks involved. Altitude:
only scenarios that show building blocks from 5 interacting. Not a use-case catalogue.

Skills: topic `runtime-view`; no subtopic skills.

**7 — Deployment View.** Cover: infrastructure level 1 — nodes and environments, and which
building blocks run where. Level 2 only when the user needs it. Altitude: where things run, not
how they are built.

Skills: topic `deployment-view`; subtopics `infrastructure-level-1`, `infrastructure-level-2`.

**8 — Crosscutting Concepts.** Cover: the recurring rules and patterns — domain model, security,
persistence, error handling, logging, UI, internationalisation, and whatever else applies.
Altitude: each concept short, with a link to where it is elaborated. No per-component detail.

Skills: topic `crosscutting-concepts`; no subtopic skills (add per-concept skills here if wanted).

**9 — Architecture Decisions.** Cover: one entry per decision — context, decision,
consequences. Altitude: link the records in `docs/adr/` (index `adr/README.md`) rather than
copying them; a decision named here that has no record gets one through the `adr` skill.

Skills: topic `architecture-decisions`; no subtopic skills.

**10 — Quality Requirements.** Cover: a quality tree, then concrete scenarios — stimulus,
response, measure. Expands 1.2. Altitude: only measurable scenarios. Unmeasurable wishes go back
to the interview until they are measurable or dropped.

Skills: topic `quality-requirements`; subtopics `quality-tree`, `quality-scenarios`.

**11 — Risks and Technical Debt.** Cover: each risk or debt item with likelihood, impact, and a
mitigation or an owner. Altitude: honest and short. No padding to look thorough.

Skills: topic `risks-and-technical-debt`; no subtopic skills.

**12 — Glossary.** Cover: a term | definition table, collected from the other sections.
Altitude: definitions of one or two sentences. No essays.

Skills: topic `glossary`; no subtopic skills.

## Pages outside arc42

Not sections. No number: H1 is the page title; parts are `## Level 1 …`, `## Level 2 …`,
`## Level 3 …`. Teammate name = the slug.

**c4 — C4 model.** Output `docs/c4.md`, teammate `c4`. Cover: Level 1 System context — the
system as one box, the roles that use it and the software systems it talks to, each line
labelled with what flows; a Mermaid `C4Context` block and a table. Level 2 Containers — the
separately runnable or deployable units inside it (apps, services, jobs, databases, queues,
stores) with technology, responsibility and how they talk; a `C4Container` block and a table
with a Decided-in column. Level 3 Components — the inside of one or two containers the user
picks: components, responsibility, dependencies; a `C4Component` block and a table per
container. Every chosen technology or structure is a decision: recorded at once as an ADR in
`docs/adr/` through the `adr` skill, linked from its table cell as `[ADR-0003](adr/0003-<slug>.md)`
and listed under a closing `## Decisions` as `- [ADR-0003: <Title>](adr/0003-<slug>.md) — <one line>`.
No `## Resources` and no `## Open questions` on this page: sources go to `docs/resources.md`;
what cannot be settled is left off the page and named in the done line. Altitude: static
structure. No runtime sequences (6), no deployment nodes (7), no code (Level 4 is not drawn),
no quality goals (1.2, 10). Imposed technology is a constraint (2), not a decision.

Skills: topic `c4`; subtopics `c4-context`, `c4-container`, `c4-component`.

## When an answer belongs elsewhere

Do not write it down. Say in one line which section it belongs to and steer back: introduction
(1), constraints (2), context and scope (3), solution strategy (4), building blocks (5), runtime
(6), deployment (7), crosscutting concepts (8), decisions (9), quality requirements (10), risks
(11), glossary (12); a container, component or neighbouring system by name (C4 page); a choice
between options (an ADR in `docs/adr/`, via the `adr` skill, linked from 9).
