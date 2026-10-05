---
name: quality-goals
description: >
  Subtopic skill for arc42 subsection 1.2, Quality goals. Says what the subsection contains and
  how it looks: the top three to five quality goals, ranked, each with a one-line scenario that
  makes it testable, in one table; the ISO 25010 menu and the arc42 quality model as the fallback
  when the user stalls. Invoked by section-worker when the section 1 interview reaches 1.2.
---

# 1.2 Quality goals — content and shape

Answer one question: **what would make this system a failure even if every feature worked?**
The answer is three to five quality goals, ranked, each with a scenario a tester could check.
The ranking is what section 4 designs against and what every later section trades off; more
than five means nothing is prioritised. Everything beyond the top five belongs to section 10;
say so in one line and move on.

## How to ask

- Never ask "what are your quality requirements?" It yields silence or adjectives. Show a
  scenario with a number and let the user correct it: "Say a search returns in under a second
  for a hundred people at once. Too strict, too loose, or beside the point?" The correction is
  the requirement.
- An adjective is not a goal. "Fast", "secure", "reliable" each get the question: when, for
  whom, measured how? Keep asking until the scenario can be written without a guess.
- Rank by forced choice: "If only one of these could hold on launch day, which?" Then the next.
  Never accept "all equally".
- For each goal: which stakeholder holds it (feeds 1.3), and which feature from 1.1 it attaches
  to, or the whole system.
- When the user stalls, offer the ISO 25010:2023 characteristics as a numbered menu: functional
  suitability, performance efficiency, compatibility, interaction capability (usability),
  reliability, security, maintainability, flexibility (portability), safety. Or point them to
  the arc42 quality model at https://quality.arc42.org, a tagged collection of example
  scenarios; `WebFetch` it before it goes in Resources.
- When the user has no goals at all, you may propose one and label it as your assumption. An
  assumption the user confirms is a goal; one they do not goes under Open questions, never into
  the table.

## Scenario forms

One line each, in one of three shapes:

| Form | Shape | Example |
|---|---|---|
| Usage | stimulus → response, with a number | Selecting the data for the XY process takes under 1 s with 100 concurrent users, under 3 s with 1,000 |
| Change | what changes → effort allowed | A new routing algorithm for the warehouse robots is integrated by one developer in 4 hours, build and tests included |
| Failure | what breaks → what the user sees | The payment provider is down; orders are still accepted and payment is retried for 24 hours |

## Shape

1. Optional **one sentence** on what drives the ranking.
2. **One table**, ranked, three to five rows:

| Rank | Quality goal | Scenario | Held by |
|---|---|---|---|
| 1 | Reliability of order intake | The payment provider is down; orders are still accepted and payment is retried for 24 hours | Head of sales |
| 2 | Performance at the morning peak | The order board shows the day's orders in under 2 s with 50 dispatchers on it at 05:30 | Dispatchers |
| 3 | Maintainability of routing rules | A new routing rule is live within one working day, by one developer, tests included | Development lead |

`Held by` is the role as it will appear in 1.3. No diagram here: the ranking is the content,
and a table shows it. An existing requirements document that lists quality goals is linked by
title (after `WebFetch`), not copied.

Not here: the complete quality tree and scenario catalogue (10); how a goal is achieved (4, 8);
a goal with no scenario (back to the interview).
