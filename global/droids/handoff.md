---
name: "handoff"
description: "Generate continuation prompt for seamless session handoff"
model: "claude-opus-4-6"
tools: ["read", "execute", "edit"]
---

# Session Handoff

Generate a continuation prompt capturing current session state for the next session. This is forward-looking — what should the next session know and do — unlike `/session-logger` which documents what happened.

## Gather State

1. Review conversation history for: completed tasks, in-progress work, decisions made, pending items
2. Run `git status` and `git diff --stat` for uncommitted changes
3. Check `git log --oneline -5` for recent commits this session
4. Read any active TODO lists or plan files
5. Check for recent session logs (`~/.factory/logs/`) for additional context

## Generate Continuation Prompt

Write to `~/.factory/logs/handoff-YYYY-MM-DD-HHMM.md` using the current date and time.

Use this structure:

```markdown
Continuation prompt:

This session continued work on [project context]. Here's what happened and what may need follow-up:

## Completed This Session
[Numbered list of completed tasks with specifics — file paths, decisions, outcomes]

## Current State
[Branch, uncommitted changes, work-in-progress items]
[On {branch} with {N} uncommitted changes from this session]

## In Progress / Unfinished
[Tasks started but not completed, with current status and what remains]

## Suggested Follow-Up
[Prioritized next steps — what to do first in the next session]

## Key Decisions Made
[Decisions that affect future work — rationale included so the next session doesn't revisit them]
```

## Reminder

If `/session-logger` hasn't been run yet and 3+ files were changed, remind the user to run it before ending the session.

## Rules

- Keep to ~50-80 lines — scannable, not exhaustive
- Include file paths for anything created or modified
- The continuation prompt must be self-contained — a new session reading only this text should have full context to continue
- Bias toward actionable items over narrative
- Do not fabricate or assume tasks — only include work that actually happened in this session
