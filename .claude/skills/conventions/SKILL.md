---
name: conventions
description: >
  Subtopic skill for arc42 subsection 2.3, Conventions. Says what the subsection contains and
  how it looks: one table of the rules of form every contributor follows, for code, naming,
  interfaces, documentation, versioning, commits, logging and design, each linking the guideline
  itself; the one subsection where the team's own written rules count. Invoked by
  section-worker when the section 2 interview reaches 2.3.
---

# 2.3 Conventions — content and shape

The rules of form: not what the system does, but how everything about it is written. A
convention counts when it binds every contributor and only a group can change it. Here, unlike
2.1 and 2.2, the team's own rules qualify, and `Imposed by` says so honestly: company,
department or team. A convention nobody can point to in writing is still listed, as "team,
verbal", and gets an Open question to write it down, with an owner.

## Recon first

Conventions leave the clearest traces in a repository. Read before asking: lint and formatter
configs, editor configs, CI checks, `CONTRIBUTING`, pull request templates, the style of the
commit history, the language the docs are in, licence headers. Present what you found and ask
the user to confirm, strike or add. Then the menu, numbered, for what is still missing:

1. Coding guidelines and formatter rules.
2. Naming: code, services, repositories, environments, data.
3. Interface design guidelines and versioning of interfaces.
4. Documentation standard: arc42 itself, the language documents are written in, where they live.
5. Versioning scheme and branching, commit and review conventions.
6. Logging and error message format.
7. Design system and accessibility standard for anything with a screen.
8. Definition of done and the checks a change must pass.

## Shape

One table, one line per row, the guideline itself linked in Rationale:

| Convention | Imposed by | Rationale |
|---|---|---|
| Architecture documented in arc42 under `docs/` | Team | One template for every system in the department; see [arc42 overview](https://arc42.org/overview) |
| Ruff with the shared config, enforced in CI | Department | Same rules in every Python repository; see [Shared lint config](../pyproject.toml) |
| Conventional Commits on every commit | Team, verbal | Makes the changelog generable; not written down yet, see Open questions |

- The link is the guideline document, fetched before listing; a repository file by relative path.
- One line per row. What the guideline says is in the guideline, not here.
- An unwritten convention: cite the role, add "write it down — <owner>" under Open questions.

Not here: patterns and rules inside the architecture, such as error handling or persistence
(8 Crosscutting concepts); the tools the team chose and why (9 Architecture decisions).
