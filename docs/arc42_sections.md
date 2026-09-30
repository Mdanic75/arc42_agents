# arc42 section briefs

Read by `section-worker` before it interviews: find your section, cover what its *Cover* lists,
in order, and stay at its *Altitude* — what the note must not descend into. This file is not an
arc42 section.

Every note: H1 `# <N>. <Section>`, subsections `## <N>.1 …`, `## <N>.2 …`.

Each brief ends with a `Skills:` line — its topic skill and subtopic skills, files at
`.claude/skills/<name>/SKILL.md`. The orchestrator passes these names to the worker; the worker
invokes the topic skill before the interview and each subtopic skill when it reaches that
subsection. A skill wins over the brief; the brief is the fallback when a skill is missing. Add a
name here to have the orchestrator pass it.

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
Nothing about the inside.

Skills: topic `context-and-scope`; subtopics `business-context`, `technical-context`.

**4 — Solution Strategy.** Cover: the key technology decisions, the top-level decomposition, the
approach taken to each quality goal from 1.2, organizational decisions that shape the
architecture. Altitude: a short paragraph or a few bullets per item, each pointing to where
sections 5–9 elaborate.

Skills: topic `solution-strategy`; no subtopic skills.

**5 — Building Block View.** Cover: level 1, a whitebox of the whole system — its blackboxes,
each with name, responsibility and interfaces. Deeper levels only where the user wants them.
Altitude: static structure only. Behaviour belongs to 6, infrastructure to 7.

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
consequences. Altitude: link existing ADR files rather than copying them.

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

## When an answer belongs elsewhere

Do not write it down. Say in one line which section it belongs to and steer back: introduction
(1), constraints (2), context and scope (3), solution strategy (4), building blocks (5), runtime
(6), deployment (7), crosscutting concepts (8), decisions (9), quality requirements (10), risks
(11), glossary (12).
