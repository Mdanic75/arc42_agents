---
name: organizational-constraints
description: >
  Subtopic skill for arc42 subsection 2.2, Organizational constraints. Says what the subsection
  contains and how it looks: one table of the team, time, money, process, contract, legal and
  political rules the team did not choose, each with who imposed it and a one-line rationale
  linking its source. Invoked by section-worker when the section 2 interview reaches 2.2.
---

# 2.2 Organizational constraints — content and shape

The non-technical rules handed to the team: who builds it, by when, for how much, under which
process, contract and law. These shape the architecture as much as any platform and are the
rows most often left out. Time and budget are asked for directly, every time. The topic skill's
three tests apply to every candidate.

## Menu

Offer these, numbered, only after the user's own list has run dry:

1. Team: size, skills, location, who owns the system after launch.
2. Budget: the ceiling, and what it must cover.
3. Deadlines and milestones: fixed dates and what fixes them (a contract, a season, a law).
4. Development process and release cadence imposed from outside: gates, approvals, freeze windows.
5. Contracts and vendors: approved supplier lists, existing licences, outsourced parts.
6. Legal and regulatory: data protection, sector regulation, accessibility law, export control.
7. Company policies: cloud, open source, certifications the system must hold.
8. Operations model: who runs it, support hours and service levels promised to customers.
9. Political: a department's say, a partner's veto. Stated as roles, factually, no colour.

For each: the cost in one clause where it is significant; whom to negotiate with where it is
negotiable.

## Shape

One table, one line per row, as many rows as are real; typically three to eight:

| Constraint | Imposed by | Rationale |
|---|---|---|
| Live before 1 November, when the carrier contract starts | Head of logistics | Contract date is fixed; see [Carrier contract summary](../contracts/carrier.md) |
| Personal data stays in the EU | Data protection officer | GDPR and company policy; see [Data protection policy](../policies/data-protection.md) |
| Four developers, two of them part time, until March | Department head | Approved staffing for the year; see [Project charter](../project/charter.md) |

- `Imposed by` is a role, team or body, not a person's name unless the user wants it there.
- The source is linked inline in Rationale: relative path for a repository file, fetched URL for
  an external document. A constraint only ever said aloud cites the role and also goes to Open
  questions for confirmation.
- The row says what is constrained, never how the team copes with it.

Not here: the team's own process choices (9 Architecture decisions); the people behind the roles
and what they expect (1.3 Stakeholders); the risk a constraint creates (11).
