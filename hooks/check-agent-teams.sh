#!/usr/bin/env bash
# SessionStart hook of the arc42 plugin. The plugin cannot ship env, teammateMode or permissions
# settings, so this warns into the session context when the target repository has not enabled
# Agent Teams. Silent when it has. Always exits 0.
if [ "${CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS:-}" = "1" ]; then
  exit 0
fi
cat <<'MSG'
arc42 plugin: Agent Teams is off in this repository, so the arc42 orchestrator cannot spawn the interactive section workers (they would run as silent subagents the user cannot talk to). Add this to .claude/settings.json and restart Claude Code:
{"env":{"CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS":"1"},"teammateMode":"in-process","permissions":{"allow":["WebSearch","WebFetch"]}}
MSG
exit 0
