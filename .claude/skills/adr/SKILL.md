---
name: adr
description: >
  Decision skill for section-worker. Invoked the moment a decision surfaces in any section or
  page, foremost the C4 page: interviews for that one decision, writes it as a MADR 4.0 file
  docs/adr/NNNN-<slug>.md, appends the index row in docs/adr/README.md and hands back the link to
  put on the page. A decision interviewer who forces at least two considered options, gets the
  "because", records consequences both ways and asks how compliance is confirmed.
---

# Decision records — one decision, one file

You are recording **one decision**: a choice the team made between real options, written so
that someone in a year understands why. The record is a MADR 4.0 file in `docs/adr/`, the index
row that points at it, and the link you hand back to the page that raised it. Then you return
to that page. Expect five to eight exchanges per decision.

Base rules stand: ask in plain text here, wait for the typed reply, no `AskUserQuestion`, no
invented facts or links, draft approval before writing.

## Is it a decision?

Three tests before any question about content:

1. **Imposed from outside?** Then it is a constraint (2), not a decision. Say so, record nothing.
2. **Was there a second option?** None after one prompt — "what would you have done had X not
   been available?" — makes it a fact, not a decision. Record nothing.
3. **Already in `docs/adr/README.md`?** Link the existing record. The decision has changed →
   supersede (below), never a second file with the same title.

Also: too small to matter in a year → no record, say so in one line. One candidate that bundles
two choices → two records, one at a time.

## Interview

Two or three numbered questions per message; one sentence back in your own words after each
answer, then the follow-up. In this order:

1. What problem forced a choice? Which containers or components does it touch?
2. What else was on the table? Name every option someone actually argued for.
3. Why this one — which driver settled it?
4. What got worse because of it?
5. How would a reviewer see the decision is being followed — a check, a test, a config line?
6. Who decided, who was consulted, who was told? When — the month is enough.

Never invent an option, a consequence, a person or a link. What the user cannot settle goes in
`## More Information` as an open point with who can answer it, and the status is `proposed`.

## MADR 4.0 shape

Title: imperative, "Use X for Y", under eight words, no colon. File, in this order (template
4.0.0, 2024-09-17; optional parts may be dropped, never renamed):

- Front matter: `status`, `date`, `decision-makers`, `consulted`, `informed`.
- `# <Title>`
- `## Context and Problem Statement` — two or three sentences or a question; names the
  containers or components affected and links the page that raised it.
- `## Decision Drivers` — optional; two to five bullets.
- `## Considered Options` — two to four, as bullets, the chosen one included.
- `## Decision Outcome` — `Chosen option: "<option>", because <one clause>.`
  - `### Consequences` — at least one `* Good, because …` and one `* Bad, because …`.
  - `### Confirmation` — the check, or "none yet" and who could add one.
- `## Pros and Cons of the Options` — when there were three or more options or the user argued;
  one `### <option>` each, bullets `* Good, because …`, `* Neutral, because …`, `* Bad, because …`.
- `## More Information` — links: the official documentation of the chosen technology (opened
  with `WebFetch` first), tickets, related records, the page that raised it; open points.

Links inside a record are relative to `docs/adr/`: `../c4.md`, `../constraints.md`,
`0002-<slug>.md`. The official documentation you opened also goes to `docs/resources.md` under
`## External`.

## Status

Lowercase, as MADR writes it: `proposed` (not yet taken, or an open point remains), `accepted`
(in effect), `rejected`, `deprecated`, `superseded by ADR-NNNN`. `date` is the day of the last
status change.

## File, number, index

1. Draft the whole record here and ask the user to approve or amend. Write only after approval.
2. Compute the number **immediately before the write**, never earlier: glob
   `docs/adr/[0-9][0-9][0-9][0-9]-*.md`, take the highest four-digit prefix plus one, zero-padded
   to four digits; `0001` when there is none. `README.md` never matches.
3. Slug: the title lowercased, every run of characters outside `a–z` and `0–9` becomes one
   hyphen, no leading or trailing hyphen, at most six words.
   "Use PostgreSQL for the order store" → `0003-use-postgresql-for-the-order-store.md`.
4. The path exists already → someone wrote in between: recompute, never overwrite. `Write` the file.
5. `Edit` `docs/adr/README.md`: append one row after the last row of the table —
   `| [0003](0003-use-postgresql-for-the-order-store.md) | Use PostgreSQL for the order store | accepted | 2026-10-02 |`.
   Never remove or reorder rows. Create the file only if it is missing, with the title and the
   header `| # | Title | Status | Date |`.
6. A number, once written, never changes. A withdrawn decision gets `rejected` or `deprecated`;
   its file stays.

## Superseding

1. Write the new record, status `accepted`; its `## More Information` starts with
   `Supersedes [ADR-0002: <old title>](0002-<slug>.md).`
2. `Edit` the old record: front matter `status: "superseded by ADR-0005"` (no Markdown link in
   front matter — it would not render), `date:` today; append
   `Superseded by [ADR-0005: <new title>](0005-<slug>.md) on <date>.` to its `## More Information`.
3. `Edit` the old index row: Status `superseded by [0005](0005-<slug>.md)`, Date today.
4. On the page, a link to the old record is re-pointed to the new one.

## Hand back

Two forms, both relative to `docs/`, where the page lives:

- Table cell: `[ADR-0003](adr/0003-use-postgresql-for-the-order-store.md)`
- List line: `- [ADR-0003: Use PostgreSQL for the order store](adr/0003-use-postgresql-for-the-order-store.md) — one relational store for the whole team`

Put them where the topic skill of the page says, then continue the page where you left it.

## Example

`docs/adr/0003-use-postgresql-for-the-order-store.md`:

```markdown
---
status: "accepted"
date: 2026-10-02
decision-makers: backend lead, data engineer
consulted: platform team
informed: product owner
---

# Use PostgreSQL for the order store

## Context and Problem Statement

Orders, assignments and drivers need one transactional store that the reporting team can also
query. The Dispatch API on the [C4 page](../c4.md) is its only writer. Which database?

## Decision Drivers

* Transactions across order and assignment rows
* The platform team already runs managed PostgreSQL, see [2. Constraints](../constraints.md)
* Reporting wants SQL without an export step

## Considered Options

* PostgreSQL, managed by the platform team
* MongoDB Atlas
* The web shop's existing MySQL

## Decision Outcome

Chosen option: "PostgreSQL, managed by the platform team", because it is the only option that
gives transactions and SQL reporting on a platform the team already operates.

### Consequences

* Good, because backups, upgrades and monitoring come with the managed service
* Bad, because the shop's MySQL and this store are kept consistent by the hourly importer

### Confirmation

The Dispatch API's data source in `deploy/api.yaml` points at the managed instance; checked in
code review.

## More Information

[PostgreSQL 16 documentation](https://www.postgresql.org/docs/16/) — the version pinned by the
platform team. Revisit when the web shop is replaced. Open: retention period for closed
orders — data protection officer.
```

Index row it produces:
`| [0003](0003-use-postgresql-for-the-order-store.md) | Use PostgreSQL for the order store | accepted | 2026-10-02 |`

Not here: the structure the decision shaped (the C4 page, 5); the rule the team could not have
chosen otherwise (2 Constraints); a list of all decisions (9 Architecture decisions links the
index).
