---
name: technical-constraints
description: >
  Subtopic skill for arc42 subsection 2.1, Technical constraints. Says what the subsection
  contains and how it looks: one table of the hardware, platform, technology, interface,
  standard and data rules the team did not choose, each with who imposed it and a one-line
  rationale linking its source. Invoked by section-worker when the section 2 interview
  reaches 2.1.
---

# 2.1 Technical constraints — content and shape

The technical rules handed to the team: what it must run on, write in, talk to, comply with.
Each row is something the team would have decided differently had it been free to. The topic
skill's three tests apply to every candidate; what fails them is not in this table.

## Menu

Offer these, numbered, only after the user's own list has run dry:

1. Hardware and devices: servers, embedded targets, scanners, phones the system must run on.
2. Runtime platform and hosting: the company Kubernetes, the one allowed cloud, on-premises only.
3. Mandated languages, frameworks, products, versions, reference architectures.
4. Systems that must be integrated, with their interfaces as given.
5. Protocols and standards the interfaces must follow.
6. Data location, retention and residency rules.
7. Security baseline and mandated tooling: identity provider, secrets store, scanners.
8. Licence policy: what may be used, what may not.
9. Clients and browsers that must be supported.

For each: the version where it is versioned; the cost in one clause where it is significant.

## Shape

One table, one line per row, as many rows as are real; typically three to eight:

| Constraint | Imposed by | Rationale |
|---|---|---|
| Runs on the company Kubernetes platform | Platform team | Only supported runtime; see [Platform runbook](../ops/platform.md) |
| Java 21 LTS, no preview features | IT strategy | Company pins the current LTS; see [Java SE support roadmap](https://www.oracle.com/java/technologies/java-se-support-roadmap.html) |
| Customer master data read from SAP over the existing IDoc interface | Owner of the ERP system | Source of truth, interface as given; see [ERP integration guide](../integration/erp.md) |

- `Imposed by` is a role, team or body, not a person's name unless the user wants it there.
- The source is linked inline in Rationale: relative path for a repository file, fetched URL for
  an external document. No source → Open questions, not a bare row.
- The row says what is constrained, never how the team copes with it.

Not here: technologies the team chose (9 Architecture decisions); neighbouring systems and the
data they exchange (3 Context and scope); performance or availability targets (1.2, 10).
