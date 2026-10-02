---
name: stakeholders
description: >
  Subtopic skill for arc42 subsection 1.3, Stakeholders. Says what the subsection contains and
  how it looks: one table of roles, who fills them, and what each expects of the system and of
  this document, three to eight rows, found by searching well beyond the users. Invoked by
  section-worker when the section 1 interview reaches 1.3.
---

# 1.3 Stakeholders — content and shape

A stakeholder is anyone who must know the architecture, approve it, work with the code, run the
system, or is affected when it fails. "Everyone", "the business" and "management" are not rows;
a role with a concrete expectation is. Three to eight rows: fewer means the search stopped
early, more means the table has become an org chart.

## How to ask

- Start from 1.1: every actor named there is a row here. Ask what each one expects before
  looking further.
- Then search broadly. Only when the user has run dry, offer this menu, numbered: users by role;
  sponsor, budget owner, product owner; operations, administrators, on-call; support and
  hotline; security, compliance, audit, legal, data protection; owners of neighbouring systems;
  developers, maintainers, testers; management and steering. Most systems have a row in five or
  more of these groups.
- The expectation is twofold and concrete. **Of the system**: "What would this person complain
  about first?" **Of this document**: "Which page would they open, and how deep must it go?"
  The second half tells the workers for sections 2 to 12 whom they are writing for; never skip
  it.
- Names go in only when the user gives them and wants them in the document; otherwise the team
  or department. Never invent a name or a contact.
- If management already keeps a stakeholder register, link it by title (after `WebFetch`, or by
  relative path if it is in the repository) and keep only the rows that matter for the
  architecture.
- Classifying stakeholders by interest and influence is not done here; arc42 advises keeping
  that private.

## Shape

One table, three to eight rows, one line per cell, no diagram:

| Role | Who | Expects of the system | Expects of this document |
|---|---|---|---|
| Dispatcher | Depot teams, Hamburg and Leipzig | Every order has a driver before 06:00, without phoning the drivers | Nothing; they never open it |
| Operator | Platform team | Runs unattended at night; a failed import pages exactly one person | 7 Deployment and 6 Runtime, the error paths |
| Sponsor | Head of logistics | Dispatch at the two depots needs one planner fewer by Q3 | 1 Introduction only, a two-minute read |
| Auditor | External, yearly | Every driver assignment is traceable to the person who made it | 8 Crosscutting concepts, the audit trail |

Before the draft, check both ways: every actor in 1.1 is here; every `Held by` in 1.2 is here.
A role in one place and not the other is a question, not an edit.

Not here: neighbouring systems as systems (3.1 Business context); what the system does for a
role (1.1); rules a stakeholder imposes on the team (2.2 Organizational constraints).
