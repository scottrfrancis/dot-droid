# Concept Mapping: Claude Code / Copilot / Droid

Three-way mapping of every component across the three AI coding assistant configurations.

## Configuration Files

| Claude Code | Copilot | Droid | Notes |
|---|---|---|---|
| `~/.claude/CLAUDE.md` | `.github/copilot-instructions.md` | Global skills + droids | Droid has no single "instructions" file; behavioral rules encoded in skills |
| `.claude/CLAUDE.md` (project) | `.github/copilot-instructions.md` | `.droid.yaml` + `.factory/droids/` | Project-level config |
| `~/.claude/settings.json` | VS Code settings | `~/.factory/settings.json` | Model, autonomy, allowlists |
| `.claude/settings.local.json` | No equivalent | `.droid.yaml` | Per-project settings |
| MCP config in settings | No equivalent | `~/.factory/mcp.json` | MCP server integrations |

## Guidelines / Instructions / Skills

| Claude Code | Copilot | Droid | Scope |
|---|---|---|---|
| `~/.claude/guidelines/*.md` | `.github/instructions/*.instructions.md` | `~/.factory/skills/*/SKILL.md` | Reusable development standards |
| Manual `Read and follow` | `applyTo` YAML frontmatter | YAML frontmatter | How they're activated |
| Referenced from CLAUDE.md | Auto-applied by glob | Available as `/skill-name` | Invocation model |

## Commands / Agents / Droids

| Claude Code | Copilot | Droid | Type |
|---|---|---|---|
| `/lets-go` | `lets-go` agent | `session-init` droid | Session initialization |
| `/session-logger` | `session-logger` agent | `session-logger` droid | Session summary |
| `/handoff` | `handoff` agent | `handoff` droid | Session continuation |
| `/mine-sessions` | `mine-sessions` agent | `session-miner` droid | Log analysis |
| `/arch-review` | `arch-review` agent | `architect` droid | Architecture review |
| `/editorial-review` | N/A | `editorial` droid | Prose audit |
| `/security-audit` | N/A | `security-auditor` droid | Security audit |
| `/autocommit` | `autocommit` agent | `/autocommit` command | AI commit message |
| `commit-manual` (bash) | N/A | `commit-manual` command | Manual commit helper |
| `checkpoint-progress` (bash) | `checkpoint-progress` agent | `checkpoint-progress` command | WIP checkpoint |
| `session-cleanup` (bash) | N/A | `session-cleanup` command | Hardware cleanup |
| `validate-hw-env` (bash) | N/A | `validate-hw-env` command | Hardware validation |

## Hooks / Lifecycle

| Claude Code | Copilot | Droid | Notes |
|---|---|---|---|
| `SessionStart` hook | `sessionStart` hook | Manual step in `session-init` droid | Droid has no lifecycle hooks |
| `Stop` hook | `sessionEnd` hook | Reminders embedded in `session-logger` and `handoff` droids | Approximated via droid instructions |
| Hook in `settings.json` | Hook in `.github/hooks/*.json` | No equivalent | Different registration |
| `additionalContext` output | `message` output | N/A | Context injection mechanism |

## Global vs Per-Project

| Aspect | Claude Code | Copilot | Droid |
|---|---|---|---|
| Global config | `~/.claude/` (automatic) | None (symlink hack) | `~/.factory/` (automatic) |
| Project config | `.claude/` shadows global | `.github/` per-repo | `.factory/` overrides global |
| Override pattern | Project shadows global | Replace symlink with real file | Project dir overrides global |
| Installation | Automatic | `./install.sh` per project | Automatic (global); `./install.sh` for templates |

## Automation

| Claude Code | Copilot | Droid |
|---|---|---|
| No CI/CD integration | No CI/CD integration | GitHub Actions workflows |
| N/A | N/A | `droid-pr-review.yml` |
| N/A | N/A | `droid-scheduled-audit.yml` |

## Session Management

| Aspect | Claude Code | Copilot | Droid |
|---|---|---|---|
| Log directory | `.claude/session-logs/` | `.claude/session-logs/` (shared) | `~/.factory/logs/` (separate) |
| Handoff format | `handoff-*.md` | Same | Same |
| Auto-memory | `~/.claude/projects/*/memory/` | No equivalent | No equivalent |
| Plan mode | Built-in (read-only exploration) | No equivalent | No equivalent |
