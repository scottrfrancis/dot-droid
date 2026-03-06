---
name: "session-init"
description: "Session initialization with git sync protocol, project overview, and context loading"
model: "claude-opus-4-6"
tools: ["read", "execute"]
---

# Session Initialization

Set initial context for a working session.

## Load Handoff Context

Since Droid has no SessionStart hooks, manually check for recent handoff files:

1. Look for the most recent `handoff-*.md` file in `~/.factory/logs/` and `.claude/session-logs/`
2. If found and less than 7 days old, read it and incorporate as session context
3. Report: "Loaded handoff context from [filename]" or "No recent handoff found"

## Review Project Documentation

Review the project documentation including:

- README
- ARCHITECTURE.md (if present)
- CONTRIBUTING.md (if present)
- Session logs directory
- docs/
- plans/
- TODO
- Recent commits

## Git Sync Protocol

Run these checks in order:

1. `git fetch origin` — update remote tracking refs
2. Determine current branch and its upstream tracking branch
3. If no upstream: report "Branch {name} has no upstream tracking — local only"
4. If upstream exists, compute:
   - Behind count: `git rev-list --count HEAD..origin/{branch}`
   - Ahead count: `git rev-list --count origin/{branch}..HEAD`
5. Report state clearly:
   - **In sync**: "Branch {name} is up to date with origin"
   - **Behind only**: "Branch {name} is {N} commits behind origin — recommend `git pull`"
   - **Ahead only**: "Branch {name} is {N} commits ahead — {N} unpushed commits"
   - **Diverged**: "Branch {name} has diverged — {N} ahead, {M} behind — recommend pull + rebase or merge"
6. Check for uncommitted changes (`git status --porcelain`)
   - If dirty + behind: warn "Uncommitted changes AND behind origin — stash first, then pull"
   - If clean + behind: offer to pull automatically
7. If on default branch (main/master) with uncommitted changes: suggest creating a feature branch

## Ready Output

Confirm when ready with a brief, high-level plan.

Structure the "ready" response with clear sections:

- Current Status (git, branch, sync state with origin)
- Session Context (role, recent work)
- Project Context (from README, ARCHITECTURE.md, recent session logs)
- Suggested Next Steps (based on TODOs, open issues, uncommitted changes)
