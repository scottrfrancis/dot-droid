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

## Dot-Repo Sync Check (dot-droid / `~/.factory`)

Run this quick check before reporting "picked up" — catches stale global config before the user resumes work. This is consistent with `/lets-go`, `/handoff`, and `/session-logger`.

1. **Locate the dot-droid clone**:

   ```bash
   DOT_DROID=""
   if [[ -L "$HOME/.factory" ]]; then
     FACTORY_TARGET=$(readlink -f "$HOME/.factory" 2>/dev/null)
     CANDIDATE="$(dirname "$FACTORY_TARGET")"
     [[ -d "$CANDIDATE/.git" ]] && DOT_DROID="$CANDIDATE"
   elif [[ -d "$HOME/.factory/.git" ]]; then
     DOT_DROID="$HOME/.factory"
   fi
   ```

2. **If located**, run: `git -C "$DOT_DROID" fetch origin` then rev-list behind/ahead and `status --porcelain`.

3. **Alert prominently** if out of sync:

   - **Behind**: "⚠ dot-droid is {N} commits behind origin — run `git -C $DOT_DROID pull` before continuing."
   - **Ahead**: "dot-droid has {N} unpushed commits."
   - **Dirty**: "dot-droid has uncommitted changes."

4. **If not located**, skip silently.

## Output

Report back concisely:

```
Picked up: [filename] (from [tool name] session)
[dot-droid sync status if any drift was detected]

Continuing: [one-line summary of what was in-progress, from the handoff]

Next step: [top item from the "Suggested Follow-Up" section]
```

Then wait for the user to confirm or redirect.

## Rules

- Do not run project-repo git commands (status, log, diff, branch) — the handoff already captures that context. The dot-droid sync check above is the ONLY exception.
- Do not read project docs, README, or ARCHITECTURE
- Do not check project branch status or uncommitted changes
- Keep output to ~5 lines (plus a sync-drift line if relevant) — the handoff already has the context
- If the "Suggested Follow-Up" section is empty or missing, ask the user what to tackle first
