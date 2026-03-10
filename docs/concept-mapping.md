# Concept Mapping: Claude Code / Copilot / Droid

Three-way mapping of every component across the three AI coding assistant configurations. Use this as a translation guide when switching between tools.

## The 30-Second Translation

If you know Claude Code, here's the cheat sheet:

| You're used to... | In Droid, do this instead |
|---|---|
| `claude` | `droid` |
| `/lets-go` | `/lets-go` (same name) |
| `/session-logger` | `/session-logger` (same name) |
| `/handoff` | `/handoff` (same name) |
| `/arch-review` | `/arch-review` (same name) |
| `/security-audit` | `/security-audit` (same name) |
| `/editorial-review style` | `/editorial-review` then describe the style in chat |
| `/mine-sessions days:30` | `/mine-sessions` then say "last 30 days" |
| `/autocommit -y` | `/autocommit` then confirm in chat |
| `~/.claude/guidelines/shell-scripts.md` | `/shell-scripts` skill or "follow the shell-scripts skill" |
| SessionStart hook auto-loads handoff | `/pickup` — dedicated post-context-clear resume |
| `/lets-go` (fresh session start) | `/lets-go` (same name) |
| Stop hook reminds about logging | `/session-logger` and `/handoff` cross-remind each other |

## Configuration Files

| Claude Code | Copilot | Droid | Notes |
|---|---|---|---|
| `~/.claude/CLAUDE.md` | `.github/copilot-instructions.md` | Global skills + droids | Droid has no single "instructions" file; behavioral rules encoded in skills and droid frontmatter |
| `.claude/CLAUDE.md` (project) | `.github/copilot-instructions.md` | `.droid.yaml` + `.factory/droids/` | Project-level config |
| `~/.claude/settings.json` | VS Code settings | [`~/.factory/settings.json`](https://docs.factory.ai/cli/configuration/settings) | Model, autonomy, allowlists |
| `.claude/settings.local.json` | No equivalent | `.droid.yaml` | Per-project settings |
| MCP config in settings | No equivalent | [`~/.factory/mcp.json`](https://docs.factory.ai/cli/configuration/mcp) | MCP server integrations |

## Guidelines / Instructions / Skills

| Claude Code | Copilot | Droid |
|---|---|---|
| `~/.claude/guidelines/*.md` | `.github/instructions/*.instructions.md` | [`~/.factory/skills/*/SKILL.md`](https://docs.factory.ai/cli/configuration/skills) |
| Manual `Read and follow` reference in CLAUDE.md | `applyTo` YAML frontmatter (auto-applied by glob) | YAML frontmatter; invoked via `/skill-name` or by reference |

### How activation works, concretely

**Claude Code** — you write in `CLAUDE.md`:
```markdown
Follow ~/.claude/guidelines/conventional-commits.md for all commits.
```

**Copilot** — the instruction file auto-applies via frontmatter:
```yaml
---
applyTo: "**"
---
```

**Droid** — you invoke in conversation:
```
you> Follow the conventional-commits skill for this commit.
# or
you> /conventional-commits
```

## Commands / Agents / Droids

| Claude Code | Copilot | Droid | Invocation Example |
|---|---|---|---|
| `/lets-go` | `lets-go` agent (dropdown) | `/lets-go` | `you> /lets-go` |
| SessionStart hook (post-clear) | N/A | `/pickup` | `you> /pickup` |
| `/session-logger [topic]` | `session-logger` agent | `/session-logger` | `you> /session-logger` then "topic: auth hardening" |
| `/handoff [notes]` | `handoff` agent | `/handoff` | `you> /handoff` |
| `/mine-sessions days:30` | `mine-sessions` agent | `/mine-sessions` | `you> /mine-sessions` then "analyze last 30 days" |
| `/arch-review` | `arch-review` agent | `/arch-review` | `you> /arch-review` |
| `/editorial-review "Paul Graham"` | N/A | `/editorial-review` | `you> /editorial-review` then "review blog-post.md in Paul Graham's style" |
| `/security-audit` | N/A | `/security-audit` | `you> /security-audit` |
| `/autocommit -y -t fix` | `autocommit` agent | `/autocommit` | `you> /autocommit` then "this is a bug fix, auto-confirm" |
| `~/.claude/commands/commit-manual feat auth "msg"` | N/A | `~/.factory/commands/commit-manual feat auth "msg"` | Run from terminal directly |
| `~/.claude/commands/checkpoint-progress` | `checkpoint-progress` agent | `~/.factory/commands/checkpoint-progress` | Run from terminal directly |
| `~/.claude/commands/session-cleanup` | N/A | `~/.factory/commands/session-cleanup` | Run from terminal directly |

### Key invocation differences

- **Claude Code**: `/command-name arguments` — arguments passed via `$ARGUMENTS` variable
- **Copilot**: Select agent from dropdown, then describe what you want in chat
- **Droid**: `/droid-name` or `/command-name`, then provide context in natural language. No structured argument passing.

**Example — the same operation in all three tools:**

```
# Claude Code
/session-logger performance

# Copilot
[select session-logger agent from dropdown]
> Create a session log with topic: performance

# Droid
/session-logger
> Topic for this session log: performance
```

## Hooks / Lifecycle

| Claude Code | Copilot | Droid | Notes |
|---|---|---|---|
| `SessionStart` hook in `settings.json` | `sessionStart` in `.github/hooks/*.json` | No equivalent | Droid has no lifecycle hooks |
| `Stop` hook in `settings.json` | `sessionEnd` in `.github/hooks/*.json` | No equivalent | Approximated via droid instructions |
| Hook outputs `additionalContext` | Hook outputs `message` | N/A | Context injection mechanism |

### How session lifecycle works in practice

**Claude Code**: Fully automatic. SessionStart hook injects last handoff. Stop hook reminds you to log. You just type `/session-logger` and `/handoff` when prompted.

**Droid**: Manual. Start every session with `/lets-go` (it checks for handoffs and syncs git). End every session with `/session-logger` then `/handoff`. The droids remind you about each other, but you have to remember to start and end the cycle.

## Global vs Per-Project

| Aspect | Claude Code | Copilot | Droid |
|---|---|---|---|
| Global config | `~/.claude/` (auto-loaded) | None (requires symlink per project) | `~/.factory/` (auto-loaded) |
| Project config | `.claude/` shadows global | `.github/` per-repo | `.factory/` overrides global |
| Override pattern | Project shadows global | Replace symlink with real file | Same-named file in `.factory/` wins |
| Installation | Automatic for all projects | `./install.sh` per project | Automatic (global); `./install.sh` for project templates |

### Override example

To customize the `arch-review` droid for one project:

**Claude Code**: Create `.claude/commands/arch-review.md` in the project (shadows `~/.claude/commands/arch-review.md`)

**Copilot**: Replace `.github/agents/arch-review.md` symlink with a real file

**Droid**: Create `.factory/droids/arch-review.md` in the project (overrides `~/.factory/droids/arch-review.md`)

## Automation / CI/CD

| Claude Code | Copilot | Droid |
|---|---|---|
| No CI/CD integration | No CI/CD integration | GitHub Actions workflows |
| N/A | N/A | `droid-pr-review.yml` — auto-reviews PRs |
| N/A | N/A | `droid-scheduled-audit.yml` — weekly security/arch audit |

## Session Management

| Aspect | Claude Code | Copilot | Droid |
|---|---|---|---|
| Log directory | `.claude/session-logs/` | `.claude/session-logs/` (shared) | `.factory/logs/` (per-project) |
| Handoff format | `handoff-YYYY-MM-DD-HHMM.md` | Same | Same |
| Auto-memory | `~/.claude/projects/*/memory/` | No equivalent | No equivalent |
| Plan mode | Built-in (enforced read-only) | No equivalent | No equivalent |
| Cross-tool handoff | N/A | Reads `.claude/session-logs/` | `lets-go` checks both `.factory/logs/` and `.claude/session-logs/` |
