# dot-droid

Portable Factory.AI Droid configuration — the Droid equivalent of `~/.claude/`.

Provides global droids (subagents), commands, skills, and settings that install to `~/.factory/`. Companion to [dot-copilot](https://github.com/scottfrancis/dot-copilot) and the user's `~/.claude/` configuration.

## Quick Start

```bash
# Install global configuration (symlinks to ~/.factory/)
./install.sh --global

# Install project template (copies .droid.yaml + .factory/ to target)
./install.sh /path/to/your/project
```

## What's Included

### Droids (Custom Subagents)

| Droid | Claude Code Equivalent | Purpose |
|---|---|---|
| `architect` | `/arch-review` | Principal Architect review against Well-Architected frameworks |
| `session-init` | `/lets-go` | Session initialization with git sync and handoff loading |
| `session-logger` | `/session-logger` | Structured session summary with cross-linking |
| `handoff` | `/handoff` | Continuation prompt for seamless session handoff |
| `session-miner` | `/mine-sessions` | Analyze session logs for patterns and metrics |
| `editorial` | `/editorial-review` | Audit prose for AI tells and refine voice/tone |
| `security-auditor` | `/security-audit` | Breach-driven security audit for web applications |

### Commands

| Command | Type | Purpose |
|---|---|---|
| `autocommit` | Markdown | AI-powered conventional commit message generation |
| `commit-manual` | Bash | Manual conventional commit helper |
| `checkpoint-progress` | Bash | WIP commit and session state preservation |
| `session-cleanup` | Bash | Kill stale processes, clean hardware environment |
| `validate-hw-env` | Bash | Hardware environment pre-check before testing |

### Skills (Development Standards)

| Skill | Purpose |
|---|---|
| `shell-scripts` | Directory management, error handling, portability |
| `conventional-commits` | Standardized commit message format |
| `readme-documentation` | README as central documentation hub |
| `session-safety` | Prevent session hangs on hardware systems |
| `ai-patterns` | LLM integration patterns: caching, routing, guardrails |
| `project-setup` | Tiered checklist for bootstrapping projects |
| `shell-escaping` | Shell quoting, TTY handling, terminal compatibility |
| `c4-diagramming` | C4 Model PlantUML organization |
| `markdown-formatting` | Spacing and formatting standards |

### GitHub Actions Workflows

| Workflow | Purpose |
|---|---|
| `droid-pr-review.yml` | Automated PR review using Droid |
| `droid-scheduled-audit.yml` | Weekly security and architecture audits |

## Directory Structure

```
dot-droid/
├── global/                     # ~/.factory/ configuration
│   ├── settings.json           # Model, autonomy, allowlists
│   ├── mcp.json                # MCP server integrations
│   ├── droids/                 # 7 custom subagents
│   ├── commands/               # 5 slash commands
│   └── skills/                 # 9 reusable skill packages
├── project/                    # Per-project template
│   ├── .droid.yaml             # PR review configuration
│   └── .factory/droids/        # Project-local overrides
├── workflows/                  # GitHub Actions templates
├── install.sh                  # Global and project installer
└── docs/                       # Concept mapping and limitations
```

## Installation Details

### Global Install (`--global`)

Creates symlinks from `~/.factory/` to this repository:

- `droids/`, `commands/`, `skills/` are **symlinked** — updates propagate automatically
- `settings.json`, `mcp.json` are **copied** — customize per-machine without affecting the repo

### Project Install

Copies template files into a target project:

- `.droid.yaml` — PR review configuration with file-specific guidelines
- `.factory/droids/` — empty directory for project-specific droid overrides

### Overrides

- **Global**: Replace a symlink in `~/.factory/` with a real file or directory
- **Project**: Add droids to `.factory/droids/` — they override same-named global droids

## Key Differences from Claude Code

| Feature | Claude Code | Droid |
|---|---|---|
| Global config | Automatic (`~/.claude/`) | Automatic (`~/.factory/`) |
| Lifecycle hooks | SessionStart, Stop | None — approximated via droids |
| Auto-memory | Built-in | Not available |
| Plan mode | Built-in read-only | Not available |
| Multi-model | Claude only | Any provider (BYOK) |
| CI/CD automation | None | GitHub Actions workflows |

See [docs/concept-mapping.md](docs/concept-mapping.md) for the full 3-way mapping and [docs/limitations.md](docs/limitations.md) for detailed workarounds.

## Version History

- 2026-03-05: Initial creation — ported from `~/.claude/` and `dot-copilot`
