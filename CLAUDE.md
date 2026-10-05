# arc42_agents

A toolkit for coordinating Claude agents that each hold their **own conversation with the user**,
reached from the same terminal. An orchestrator drives an arc42 architecture document to
completion, one section worker at a time. One generic worker type serves all twelve sections; each
note it writes ends with a Resources list of linked documentation. Beside the arc42 sections it
produces a C4 page (`docs/c4.md`, three levels) whose decisions are recorded as MADR files in
`docs/adr/` the moment they surface. The repository is packaged as the Claude Code plugin `arc42`
so it runs against any repository; see *Using it from another repository*.

## The mechanism

It is Claude Code's built-in **Agent Teams**, not custom machinery. The repository being
documented enables it in its `.claude/settings.json` (this repository's own copy serves
development here; a plugin cannot ship these settings):

```json
{
  "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" },
  "teammateMode": "in-process"
}
```

A worker is a **teammate** — an interactive Claude session running inside the lead's process,
spawned by calling the Agent tool **with a `name`**. The `name` is what makes it a teammate rather
than a silent in-process subagent. The user reaches a teammate from the lead's terminal: ↓ at the
empty prompt opens the agent panel, ↑/↓ selects, Enter opens the teammate's transcript and sends
typed text to it, Esc returns to the lead. Built-in `/` commands always run in the lead.
Teammates report a one-line status back to the lead with `SendMessage`.

Start the orchestrator from the repository to document, with the plugin loaded:
`claude --plugin-dir /path/to/arc42_agents --agent arc42:orchestrator`, or once installed
`claude --agent arc42:orchestrator`. Developing the toolkit here: `claude --plugin-dir . --agent
arc42:orchestrator`. Teammates reach it with `SendMessage(to: "main", …)`.

## Lifecycle

A teammate **does not exit when it finishes its task.** It goes idle and waits. Ending one is
explicit and goes through the lead; the orchestrator does it as soon as a worker reports `done:`
and leaves a `blocked:` worker up for the user:

```
SendMessage(to: "<teammate>", message: {"type": "shutdown_request", "reason": "..."})
```

The teammate approves and its session ends. Per the docs, messaging a stopped in-process teammate
brings it back with its conversation restored.

## Layout

A Claude Code plugin in the standard layout. Nothing under `.claude/` is loaded as project
configuration except `settings.json`.

- `.claude-plugin/plugin.json` — the manifest. Plugin name `arc42`, which prefixes every component:
  `arc42:orchestrator`, `arc42:section-worker`, `arc42:<skill>`.
- `.claude-plugin/marketplace.json` — makes this repository its own one-plugin marketplace
  (`arc42-agents`) for persistent installs. Nothing is published; a local path or a private git URL
  is enough.
- `agents/orchestrator.md` — drives arc42 completion: status → resolve the brief → spawn section
  worker → yield → shutdown.
- `agents/section-worker.md` — the one worker for all 12 sections and the C4 page; told the section
  or page, the skill names and the quoted brief by the orchestrator, interviews the user, gathers
  linked resources (web and internal docs), writes the section note.
- `skills/<name>/SKILL.md` — topic and subtopic skills; the names come from the skill map in the
  brief. Sections 1 and 2 have their full sets (`introduction-and-goals`, `requirements-overview`,
  `quality-goals`, `stakeholders`; `constraints`, `technical-constraints`,
  `organizational-constraints`, `conventions`). Sections 3–12 fall back to the brief until theirs
  exist. The C4 page has `c4`, `c4-context`, `c4-container`, `c4-component`; `adr` is the decision
  skill every worker may invoke, not listed per section.
- `hooks/hooks.json`, `hooks/check-agent-teams.sh` — SessionStart hook that warns into the session
  context when the repository being documented has not enabled Agent Teams. Silent otherwise.
- `skills/brief/SKILL.md` — the brief as a skill (`arc42:brief`): twelve section briefs plus the
  C4 page brief under *Pages outside arc42* (Cover / Altitude) and the skill map (a `Skills:` line
  per section). The orchestrator invokes it once per session unless the documented repository
  keeps its own `docs/arc42_sections.md`, and quotes the section's paragraph into the spawn
  prompt, so no agent reads a file outside the working directory. Not a section; to tailor it,
  copy the body below the frontmatter to `docs/arc42_sections.md`.
- `templates/resources.md`, `templates/adr/README.md` — starter copies of the shared resource index
  and the ADR index. The worker and the `adr` skill create `docs/resources.md` and
  `docs/adr/README.md` from inline templates when missing; a project may copy these to pre-fill.
- `.claude/settings.json` — enables Agent Teams, in-process, for developing the toolkit here. The
  same block must exist in every repository the plugin documents.

Everything the agents write goes to `docs/` of the working directory, that is, of the repository
being documented: `docs/<slug>.md`, `docs/c4.md`, `docs/adr/`, `docs/resources.md`.

Convention: one worker type, `section-worker` (`arc42:section-worker` as a plugin component);
teammate name = `s<N>-<slug>`, bare slug for pages outside arc42 (`c4`); output file =
`docs/<slug, - replaced by _>.md`, ending in a `## Resources` list (title + link + one-line
description, referenced inline by title where the text relies on it). The C4 page is the
exception: it ends with `## Decisions` (ADR links), has no Resources or Open questions section,
and its sources go to `docs/resources.md` only. The brief's `Skills:` lines name skills bare; the
worker invokes whichever form its list shows (`arc42:<name>` as a plugin). The documented
repository's `.claude/settings.json` allow-lists `WebSearch` and `WebFetch` so the worker's link
checks do not stall on prompts only the lead can see.

## Using it from another repository

1. In that repository, add the Agent Teams block above to `.claude/settings.json`; the hook warns
   when it is missing.
2. One session: `cd <repo> && claude --plugin-dir /path/to/arc42_agents --agent arc42:orchestrator`.
   The flag reads this working tree live; edits here are picked up at the next session start.
3. Persistent: `claude plugin marketplace add /path/to/arc42_agents` once, then
   `/plugin install arc42@arc42-agents` in that repository (project scope writes `enabledPlugins`
   to its `.claude/settings.json`), then `claude --agent arc42:orchestrator`. Installed plugins are
   cached; edits here reach them only after `claude plugin update arc42`.
4. That repository's own `CLAUDE.md` applies to the orchestrator and every worker, and an existing
   `docs/<slug>.md` there counts as a done section.

## Things already learned the hard way — do not rediscover them

- **Teammates cannot spawn teammates.** Verified at the tool layer: an Agent call *with* a `name`
  from a teammate is refused — "Teammates cannot spawn other teammates — the team roster is flat. To
  spawn a subagent instead, omit the `name` parameter." Any hierarchy of user-facing agents must be
  flat: one lead, N teammates. This is what sank the earlier master → section → worker design in
  this repo. (In iTerm2 mode a teammate could still run a background subagent without a `name`; the
  docs say in-process teammates cannot.)
- **A plain Agent call with no `name` is a silent subagent**: no conversation the user can join, no
  `AskUserQuestion`, and it inherits no `CLAUDE.md` layers — with nothing to signal the loss.
- **Agent, skill and settings changes load at session start.** A teammate type you just wrote is
  not spawnable until you restart; enabling Agent Teams or changing `teammateMode` likewise does
  nothing until restart, even though the env var shows up in subprocesses immediately.
- **Teammates launch with `--permission-mode auto`.**
- **A teammate's permission prompts and `AskUserQuestion` land in the lead session, never in the
  teammate's own view.** Measured in iTerm2 mode: the full question UI rendered in the lead's pane
  ("Waiting for team lead approval … Permission request sent to team … leader") while the teammate
  hung and later saw only the answers; the docs state the same for permission prompts in every mode.
  Allow-listing `AskUserQuestion` in `permissions.allow` changes nothing (tested 2026-09-30). So
  workers do not get the tool: they ask in plain text and wait for the typed reply.
- **In-process teammates address the lead as `main`, and have no `ListAgents`.** Measured
  2026-09-30: a worker given the lead's outside session name (the `ListAgents` "This session is
  <name>" name) had that address rejected; `main` worked; `ListAgents` was unavailable inside the
  teammate. (In iTerm2 mode teammates were separate sessions and used the lead's session name.)
- **A teammate that exits behind the lead's back leaves a ghost in the roster.** Measured in iTerm2
  mode: `/exit`, Ctrl-D or Ctrl-C in a teammate ended it, nothing told the lead, the row stayed until
  the lead restarted, and `SendMessage` to the ghost returned `success: true` with no reply ever.
  The roster only clears through the `shutdown_request` handshake. `ListAgents` is not a liveness
  check. In-process mode has no separate process to kill and revives a stopped teammate on message,
  so this should matter less there — unverified.
- **A session with a team cannot be `--resume`d** (documented limitation).
- **There is no `claude --cwd`.** The launching shell must `cd`. `--add-dir` grants tool access to
  other directories but does not change the working directory — and `CLAUDE.md` auto-discovery
  follows the working directory's ancestors and nothing else.

- **Plugins cannot carry settings** (docs, 2026-10-03): a plugin `settings.json` honors only `agent`
  and `subagentStatusLine`; `env`, `teammateMode` and `permissions` are dropped at load. Agent Teams
  is therefore enabled per documented repository; the SessionStart hook is the guard.
- **Plugin components are namespaced `arc42:<name>` everywhere.** Measured 2026-10-05 with
  `--plugin-dir`: the Agent type list shows `arc42:orchestrator` and `arc42:section-worker`, the
  skills list `arc42:adr` … `arc42:technical-constraints`; `claude --agent arc42:orchestrator`
  starts. The brief's `Skills:` lines stay bare and the worker maps.
- **A plugin's files are outside the working directory.** Measured 2026-10-05: `${CLAUDE_PLUGIN_ROOT}`
  is substituted in an agent body (the orchestrator resolved the absolute plugin path), but a `Read`
  of a file under the plugin root from another repository is denied in `-p` mode and prompts
  interactively. Content an agent needs from the plugin therefore travels as a skill (`arc42:brief`),
  which the harness loads without a file permission; never as a path.
- **The SessionStart hook sees settings `env`.** Measured 2026-10-05: the hook stayed silent where
  `.claude/settings.json` sets `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` and fired in a directory
  without it. The variable is also inherited by nested `claude` runs started from a Bash tool, so a
  hook test from inside a session needs `env -u CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`.
- **`--add-dir` grants file access only**; it does not discover `.claude/agents` or `.claude/skills`
  of the added directory (docs). That is why this is a plugin and not an added directory.
- **Marketplace installs are cached**; `--plugin-dir` reads the working tree live. Use the flag
  while developing, `claude plugin update arc42` after installing.

## If you ever go back to iTerm2 panes (`teammateMode: "iterm2"`)

Worked as of commit 176e293; dropped because one terminal is wanted. Everything below was measured.

- Claude Code does **not** close a teammate's pane when it ends; without help they pile up as dead
  `-zsh` panes. Recipe: a `SessionEnd` hook that checks its own parent process args for
  `--team-name` (teammates run as `claude --agent-id … --agent-name … --team-name … --agent-type …`;
  the lead runs as `claude --agent orchestrator` or `claude --resume …`) and closes only its own
  pane: `it2 session close --session "${ITERM_SESSION_ID#*:}" --force`. Never search for a pane.
- **`CLAUDE_CODE_CHILD_SESSION=1` is NOT a teammate marker** — it is set in the lead too; keying the
  hook on it closes the user's own pane.
- **`it2` is a native binary** (`/opt/homebrew/bin/it2` → the iTerm.app bundle); iTerm2's Python API
  (`import iterm2`) is unavailable and not needed. `it2 session list|read|close|split|send|focus`
  work; `EnableAPIServer` is `1`.
- **`it2 session read` shows a pane's live screen, not its scrollback**, and its output contains NUL
  bytes (`tr -d '\0'` before grep). A teammate's dialogue cannot be recovered that way after exit.
- **Liveness**: `ps -eo args | grep -- '--team-name'` (teammate processes) and `it2 session list`
  (panes), not `ListAgents`.
- `it2 session send` puts text in the Claude Code prompt but a separate `$'\r'` is needed to submit.

## Open questions before arc42 is built on this

Per-section personality is delivered by skills: a topic skill per section (voice, interview style,
depth) and subtopic skills per subsection (what it contains and how it looks), named per section in
the brief's `Skills:` lines and passed by the orchestrator in the spawn prompt. The brief is the
fallback when a skill is missing. The earlier idea of a working directory per worker, so nested
`CLAUDE.md` files layer a personality, is parked: it is not established that a teammate can be
rooted per directory (`isolation: "worktree"` is a git worktree, not that), and skills cover the
need. Revisit only if a section outgrows a skill.

Unverified as of 2026-10-05, in test order:

- A teammate spawned from the namespaced plugin type `arc42:section-worker` with a `name` behaves
  like one from a project agent: interactive, in the ↓ panel. The plugin design rests on this.
- An in-process teammate sees plugin skills as `arc42:<name>` and can invoke `Skill` (the main
  agent can: measured for `arc42:brief` from the orchestrator, 2026-10-05).
- `claude plugin marketplace add` with this repository's path installs `arc42@arc42-agents`
  (`claude plugin validate .` passes; the relative `source: "./"` is untested end to end).
