# arc42_agents

A toolkit for coordinating Claude agents that each hold their **own conversation with the user**,
reached from the same terminal. An orchestrator drives an arc42 architecture document to
completion, one section worker at a time. One generic worker type serves all twelve sections; each
note it writes ends with a Resources list of linked documentation.

## The mechanism

It is Claude Code's built-in **Agent Teams**, not custom machinery. `.claude/settings.json`:

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

Start the orchestrator with `claude --agent orchestrator` from this directory. Teammates reach it
with `SendMessage(to: "main", …)`.

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

- `.claude/settings.json` — enables Agent Teams, in-process.
- `.claude/agents/orchestrator.md` — drives arc42 completion: status → spawn section worker → yield → shutdown.
- `.claude/agents/section-worker.md` — the one worker for all 12 sections; told the section by the orchestrator, interviews the user, gathers linked resources (web and internal docs), writes the section note.
- `.claude/agents/demo-worker.md` — throwaway teammate that proves the user can talk to a teammate.
- `docs/resources.md` — shared index of linked documentation; pre-fill it with known sources, workers read it first and append what they use.
- `docs/arc42_sections.md` — the twelve section briefs (Cover / Altitude) and the skill map (topic skill + subtopic skills per section); the worker reads its own section, the orchestrator reads the `Skills:` line at spawn. Not a section.
- `.claude/skills/<name>/SKILL.md` — topic and subtopic skills (none yet); the names come from the skill map.

Convention: one worker type, `section-worker`; teammate name = `s<N>-<slug>`; output file =
`docs/<slug, - replaced by _>.md`, ending in a `## Resources` list (title + link + one-line
description, referenced inline by title where the text relies on it). `.claude/settings.json`
allow-lists `WebSearch` and `WebFetch` so the worker's link checks do not stall on prompts only
the lead can see.

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

## Open question before arc42 is built on this

The intended arc42 design gives each worker **its own subdirectory** so nested `CLAUDE.md` files
layer a personality onto it. Teammates are spawned by the lead, and it is **not established that a
teammate can be given its own working directory** — `isolation: "worktree"` creates a git worktree,
which is not the same thing. Settle this before building the arc42 hierarchy; if teammates cannot
be rooted per-directory, the layering needs a different delivery mechanism.

As of 2026-09-30 the per-section personality is delivered by skills: a topic skill per section
(voice, interview style, depth) and subtopic skills per subsection (what it contains and how it
looks), named per section in `docs/arc42_sections.md` and passed by the orchestrator in the spawn
prompt. The brief in that file is the fallback when a skill is missing. Whether an in-process
teammate sees project skills and can invoke `Skill` is unverified — test it with the first skill.
Per-directory layering is only needed again if a section ever outgrows a skill.
