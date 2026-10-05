# arc42_agents

A Claude Code plugin that writes an [arc42](https://arc42.org) architecture document for the
repository you run it in. An orchestrator keeps the status of the twelve sections and the C4 page,
and spawns one **section worker** at a time as a teammate: an interactive Claude session inside
the same terminal that interviews you, tracks where every fact came from, and writes
`docs/<section>.md` with inline references and a Resources list. Decisions that surface are
recorded at once as MADR files in `docs/adr/`.

## Requirements

Teammates are Claude Code's Agent Teams. The plugin cannot switch them on, so the repository you
document needs this in its `.claude/settings.json` (then restart Claude Code):

```json
{
  "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" },
  "teammateMode": "in-process",
  "permissions": { "allow": ["WebSearch", "WebFetch"] }
}
```

A SessionStart hook in the plugin prints a warning into the session when this is missing. The
allow-list keeps the worker's link checks from stalling on prompts that only the lead can see.

## Use it for one session

```bash
cd /path/to/your-repo
claude --plugin-dir /path/to/arc42_agents --agent arc42:orchestrator
```

`--plugin-dir` reads this working tree as it is at session start; no install, nothing cached.

## Install it

The repository is its own one-plugin marketplace. Nothing is published; a local path or a private
git URL is enough.

```bash
claude plugin marketplace add /path/to/arc42_agents     # once per machine
cd /path/to/your-repo
claude                                                  # then, in the session:
/plugin install arc42@arc42-agents                      # project scope → .claude/settings.json
```

From then on, `claude --agent arc42:orchestrator` in that repository. Installed plugins are
cached: after editing this repository run `claude plugin update arc42`.

## Talking to a worker

The orchestrator says which teammate is running. Press ↓ at the empty prompt to open the agent
panel, pick the worker, Enter shows its transcript and sends what you type to it, Esc returns to
the orchestrator. Built-in `/` commands always run in the orchestrator. When a worker reports
`done:` the orchestrator shuts it down and offers the next section.

## What it writes

Everything lands in `docs/` of the repository you run it in:

| Path | Written by |
|---|---|
| `docs/<section>.md`, one per arc42 section, e.g. `docs/constraints.md` | section worker |
| `docs/c4.md` — C4 context, containers, components | section worker (page outside arc42) |
| `docs/adr/NNNN-<slug>.md`, index `docs/adr/README.md` | any worker, through the `arc42:adr` skill |
| `docs/resources.md` — shared index of every linked source | section workers, created when missing |

The section briefs (what each section covers and must not descend into, and which skills shape it)
ship as the `arc42:brief` skill, `skills/brief/SKILL.md`. To tailor them, copy the body below its
frontmatter to `docs/arc42_sections.md` in your repository; the orchestrator prefers that file
when present. `templates/resources.md` and `templates/adr/README.md` are starters you may copy to
pre-fill known sources.

## Caveats

- Your repository's own `CLAUDE.md` applies to the orchestrator and to every worker.
- A file already named like a section, for example an unrelated `docs/glossary.md`, counts as that
  section being done.
- Agents, skills and settings load at session start; restart after changing them.
- A session with a team cannot be resumed with `--resume`.

## Developing the toolkit

Run it against this repository with the plugin loaded from the working tree:

```bash
claude --plugin-dir . --agent arc42:orchestrator
```

`CLAUDE.md` holds the layout, the conventions, and what has been measured about Agent Teams so
far; read it before changing an agent or a skill.
