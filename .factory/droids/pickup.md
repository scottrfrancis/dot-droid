---
name: "pickup"
description: "Resume work after context clear by loading the most recent handoff"
model: "claude-opus-4-6"
tools: ["read"]
---

# Pick Up Handoff

Resume work after a context clear. Load the most recent handoff and continue where things left off.

## Find Handoff

Search for the most recent `handoff-*.md` file across all tool locations:

1. Check `session-logs/` (shared cross-tool location)
2. Then `.factory/logs/` (Droid legacy location)
3. Then `.claude/session-logs/` (Claude Code / Copilot location)

Take the most recently modified file across all locations.

**If none found, or the file is older than 7 days**: Stop and tell the user:

```
No recent handoff found. Try /lets-go for a full session start instead.
```

## Load Context

Read the handoff file in full. If the file has YAML frontmatter with a `tool:` field, note which tool created it (e.g., "Picking up from a Cursor session" or "Last session was in Droid"). The contents become the active session context.

## Output

Report back concisely:

```
Picked up: [filename] (from [tool name] session)

Continuing: [one-line summary of what was in-progress, from the handoff]

Next step: [top item from the "Suggested Follow-Up" section]
```

Then wait for the user to confirm or redirect.

## Rules

- Do not run git commands
- Do not read project docs, README, or ARCHITECTURE
- Do not check branch status or uncommitted changes
- Keep output to ~5 lines — the handoff already has the context
- If the "Suggested Follow-Up" section is empty or missing, ask the user what to tackle first
