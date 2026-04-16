---
name: "lets-go"
description: "Session initialization with git sync protocol, project overview, and context loading"
model: "claude-opus-4-6"
tools: ["read", "execute", "azure-devops"]
---

# Session Initialization

Set initial context for a working session.

## Load Handoff Context

Since Droid has no SessionStart hooks, manually check for recent handoff files:

1. Look for the most recent `handoff-*.md` file in these locations (check all, take newest):
   - `session-logs/` (shared cross-tool location)
   - `.factory/logs/` (Droid legacy location)
   - `.claude/session-logs/` (Claude Code / Copilot location)
2. If found and less than 7 days old, read it and incorporate as session context
3. If the file has YAML frontmatter with a `tool:` field, note the source (e.g., "Continuing from a Cursor session")
4. Report: "Loaded handoff context from [filename] ([tool])" or "No recent handoff found"

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

## Azure DevOps Board Check

Always check the ADO MCP for the user's current work and review obligations. The ADO project is `project-ogc-demos-and-mvps`.

### My Active Work Items

1. Call `wit_my_work_items` with project `project-ogc-demos-and-mvps` and type `assignedtome`
2. Fetch details with `wit_get_work_items_batch_by_ids` and **filter out Resolved and Closed items** -- only show Active, New, and In Progress
3. Summarize remaining items grouped by state -- include ID, title, state, and iteration
4. Flag any items that appear blocked or stale (no recent updates)

### Pending PR Reviews

1. Call `repo_list_pull_requests_by_repo_or_project` with project `project-ogc-demos-and-mvps`, status `Active`, and `i_am_reviewer: true`
2. For each PR where the user is a reviewer, report: PR ID, title, author, and how long it has been open
3. Highlight any PRs that are waiting on the user's vote (no vote cast yet)
4. Also check for any PRs created by the user that are active: call with `created_by_me: true` and status `Active`
5. For user-created PRs, note reviewer status and any outstanding comments

## Ready Output

Confirm when ready with a brief, high-level plan.

Structure the "ready" response with clear sections:

- Current Status (git, branch, sync state with origin)
- ADO Board (active work items, any blockers or stale items)
- PR Status (PRs needing my review, my open PRs and their review state)
- Session Context (role, recent work)
- Project Context (from README, ARCHITECTURE.md, recent session logs)
- Suggested Next Steps (based on TODOs, open issues, uncommitted changes, PR reviews needed)
