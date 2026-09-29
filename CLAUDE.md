# arc42_agents

A toolkit for coordinating Claude agents that each hold their **own conversation with the user**,
in their own terminal pane. The current contents are a minimal, generic MVP of that mechanism;
arc42 content is not here yet.

## The mechanism

It is Claude Code's built-in **Agent Teams**, not custom machinery. `.claude/settings.json` turns
it on:

```json
{
  "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" },
  "teammateMode": "iterm2"
}
```

A worker is a **teammate** — a full, independent Claude Code session in its own iTerm2 pane,
spawned by calling the Agent tool **with a `name`**. The `name` is what makes it a teammate rather
than an in-process subagent. The user talks to each teammate directly in its pane; teammates
report a one-line status back to the lead with `SendMessage`.

Start the orchestrator with `claude --agent orchestrator`. It learns its own session name from
`ListAgents` (whose first line tells a session what it is called) and writes that name into each
teammate's prompt as the reply address.

## Lifecycle — the non-obvious part

A teammate **does not exit when it finishes its task.** It goes idle and waits, because it is an
interactive session the user may still be talking to. Ending one is explicit:

```
SendMessage(to: "<teammate>", message: {"type": "shutdown_request", "reason": "..."})
```

The teammate approves, its session ends, and the `SessionEnd` hook in `.claude/settings.json`
closes its pane (~2s, verified). Claude Code itself does **not** close teammate panes — without
that hook they pile up as dead `-zsh` panes.

The hook must only ever fire for teammates. It identifies one by checking its own owning process
for `--team-name`:

| session | process args | hook |
|---|---|---|
| lead / orchestrator | `claude --resume …`, `claude --agent orchestrator` | exits 0, closes nothing |
| teammate | `claude --agent-id … --agent-name … --team-name … --agent-type …` | closes its own pane |

It closes only `${ITERM_SESSION_ID#*:}` — its own pane id, taken from its own environment. It never
searches for a pane.

**`CLAUDE_CODE_CHILD_SESSION=1` is NOT a teammate marker** — it is set in the lead session too.
Keying the hook on it closes the user's own pane. Measured, not assumed.

## Layout

- `.claude/settings.json` — enables Agent Teams, iTerm2 panes, and the pane-closing `SessionEnd` hook.
- `.claude/agents/orchestrator.md` — spawns teammates, yields, collects statuses, tears down.
- `.claude/agents/demo-worker.md` — throwaway teammate that proves the mechanism end to end.

## Things already learned the hard way — do not rediscover them

- **Teammates cannot spawn teammates, but they CAN spawn in-process subagents.** Verified at the
  tool layer. A teammate does have the Agent tool; an Agent call *with* a `name` is refused —
  "Teammates cannot spawn other teammates — the team roster is flat. To spawn a subagent instead,
  omit the `name` parameter." — while an Agent call *without* a `name` succeeds and runs an
  ordinary background subagent with no pane and no TTY.
  So a worker can delegate silent background work, but it can never create another pane the user
  can talk to. Any hierarchy of *user-facing* agents must be flat: one lead, N teammates. This is
  the exact reason the earlier master → section → worker design in this repo failed.
- **A plain Agent call with no `name` is an in-process subagent**: no pane, no TTY, no
  `AskUserQuestion`, and it inherits no `CLAUDE.md` layers — with nothing to signal the loss.
- **Agent, skill and settings changes load at session start.** A teammate type you just wrote is
  not spawnable until you restart; enabling Agent Teams likewise does nothing until restart, even
  though the env var shows up in subprocesses immediately.
- **Teammates launch with `--permission-mode auto`.**
- **iTerm2's Python API is unavailable here** (no `iterm2env`, `import iterm2` fails) — irrelevant.
  `it2` is a native binary (`/opt/homebrew/bin/it2` → the iTerm.app bundle) that speaks the iTerm2
  API with no Python, and `EnableAPIServer` is `1`. `it2 session list|read|close|split|send|focus`
  all work. `teammateMode: "iterm2"` needs `it2`, not the Python module.
- **`it2 session read` shows a pane's live screen, not its scrollback.** Once a session exits, its
  transcript is gone from the pane — do not plan to recover a teammate's dialogue that way.
- **A session learns its own name from `ListAgents`** — first line, "This session is <name>"; self
  is excluded from the peer list.
- **There is no `claude --cwd`.** The launching shell must `cd`. `--add-dir` grants tool access to
  other directories but does not change the working directory — and `CLAUDE.md` auto-discovery
  follows the working directory's ancestors and nothing else.

## Open question before arc42 is built on this

The intended arc42 design gives each worker **its own subdirectory** so nested `CLAUDE.md` files
layer a personality onto it. Teammates are spawned by the lead, and it is **not established that a
teammate can be given its own working directory** — `isolation: "worktree"` creates a git worktree,
which is not the same thing. Settle this before building the arc42 hierarchy; if teammates cannot
be rooted per-directory, the layering needs a different delivery mechanism.
