# dot-droid

Portable [Factory.AI Droid](https://docs.factory.ai/) configuration — the Droid equivalent of `~/.claude/`.

Provides global droids (subagents), commands, skills, and settings that install to `~/.factory/`. Companion to [dot-copilot](https://github.com/scottfrancis/dot-copilot) and the user's `~/.claude/` configuration.

If you're coming from Claude Code, this is the translation layer. Everything you do with `/lets-go`, `/session-logger`, and `~/.claude/guidelines/` has a Droid equivalent here — the invocations just look different.

## Prerequisites

1. **Install Droid CLI** ([quickstart](https://docs.factory.ai/cli/getting-started/quickstart)):

   ```bash
   curl -fsSL https://app.factory.ai/cli | sh
   # or
   brew install factory-ai/tap/droid
   ```

2. **Authenticate** — run `droid` once and follow the browser prompt. This creates `~/.factory/config.json` with your credentials.

3. **Clone this repo** somewhere permanent (symlinks will point here):

   ```bash
   cd /Volumes/workspace
   git clone https://github.com/scottfrancis/dot-droid.git
   cd dot-droid
   ```

## Installation

### Step 1: Install global configuration

```bash
./install.sh --global
```

This creates `~/.factory/` and populates it:

```
~/.factory/
├── settings.json       # COPIED — edit freely for your model/autonomy prefs
├── mcp.json            # COPIED — add your MCP servers here
├── droids/  -> /Volumes/workspace/dot-droid/global/droids/    # SYMLINKED
├── commands/ -> /Volumes/workspace/dot-droid/global/commands/  # SYMLINKED
├── skills/  -> /Volumes/workspace/dot-droid/global/skills/    # SYMLINKED
└── logs/               # Created for session logs
```

**Why the split?** `settings.json` and `mcp.json` contain machine-specific config (API keys, model preferences), so they're copied. Droids, commands, and skills are symlinked so that `git pull` on this repo updates them everywhere.

### Step 2: Install project template (per-project)

```bash
./install.sh /Volumes/workspace/catalyst-rcm-dashboard-bot
```

This copies into the target project:

```
catalyst-rcm-dashboard-bot/
├── .droid.yaml          # PR review config (file-specific review rules)
└── .factory/
    └── droids/          # Add project-specific droids here
```

### Step 3: Verify

```bash
# Start a Droid session in any git project
cd /Volumes/workspace/my-project
droid

# You should see your custom droids available
> /architect
> /session-init
```

## How to Use Everything

### Droids (Custom Subagents)

Droids are the Droid equivalent of Claude Code's `/slash-commands` for complex, multi-step tasks. They're markdown files with YAML frontmatter that define a specialized AI agent.

**Where they live**: `~/.factory/droids/` (global) or `.factory/droids/` (per-project override)

**How to invoke them**: Type `/droid-name` or ask Droid to "use the architect droid" in conversation.

**Reference**: [Custom Droids docs](https://docs.factory.ai/cli/configuration/custom-droids)

| Droid | Claude Code Equivalent | What It Does |
|---|---|---|
| `session-init` | `/lets-go` | Loads recent handoff, syncs git, reviews project docs, reports status |
| `session-logger` | `/session-logger` | Creates session summary in `~/.factory/logs/YYYY-MM-DD-HHMM.md` |
| `handoff` | `/handoff` | Generates continuation prompt in `~/.factory/logs/handoff-YYYY-MM-DD-HHMM.md` |
| `session-miner` | `/mine-sessions` | Analyzes `~/.factory/logs/` for patterns and metrics |
| `architect` | `/arch-review` | Full architecture review (Well-Architected, SOLID, security, AI patterns) |
| `editorial` | `/editorial-review` | Audits prose for AI tells; accepts style parameter |
| `security-auditor` | `/security-audit` | Breach-driven security audit of web applications |

#### Concrete examples

**Starting a session** (replaces `/lets-go`):

```
you> /session-init
droid> Checking for recent handoff files...
       Found: ~/.factory/logs/handoff-2026-03-05-1430.md
       Loading context from previous session...

       Running git sync...
       Branch main is 3 commits behind origin — recommend `git pull`

       Current Status:
       - Branch: main (3 behind, clean working tree)
       - Last session: refactored auth middleware, added rate limiting tests

       Suggested Next Steps:
       1. Pull latest from origin
       2. Continue with tenant isolation tests (carry-forward from last session)
```

**Ending a session** (replaces `/session-logger` + `/handoff`):

```
you> /session-logger
droid> Session log saved to ~/.factory/logs/2026-03-06-1700-auth-hardening.md
       Reminder: You changed 8 files this session. Run /handoff before closing.

you> /handoff
droid> Continuation prompt saved to ~/.factory/logs/handoff-2026-03-06-1705.md
```

**Running an architecture review**:

```
you> /architect
droid> [reads project structure, tests, configs, specs]
       ...
       Report saved to docs/arch-review-2026-03-06-170532.md

       Critical findings: 0
       High: 2 (missing rate limiting on /api/upload, no tenant isolation on /reports)
       Medium: 4
       Low: 3
```

**Auditing a blog post** (replaces `/editorial-review`):

```
you> /editorial review my draft at docs/blog-post.md in the style of Paul Graham
droid> Reading docs/blog-post.md...
       Target voice: Paul Graham (short sentences, direct claims, conversational)

       Found 11 issues:
       - 4 Mechanical: 3 em-dashes (max 2), 1 tricolon cluster
       - 3 Economy: passive constructions on lines 14, 28, 45
       - 2 Voice: third-person distancing on lines 7, 31
       - 2 Structural: throat-clearing opener, restated conclusion

       Top 3 changes:
       1. Line 7: "One might argue that..." → "The real problem is..."
       ...
       Should I apply these changes?
```

### Commands (Slash Commands)

Commands are simpler than droids — either markdown instructions or bash scripts. They handle single-purpose tasks.

**Where they live**: `~/.factory/commands/`

**How to invoke them**: Type `/command-name` in a Droid session, or run bash scripts directly from the terminal.

**Reference**: [Commands docs](https://docs.factory.ai/cli/configuration/commands) (if available, otherwise same pattern as custom droids)

| Command | Type | How to Run |
|---|---|---|
| `autocommit` | Markdown | `/autocommit` in a Droid session |
| `commit-manual` | Bash | `~/.factory/commands/commit-manual feat auth "add login"` |
| `checkpoint-progress` | Bash | `~/.factory/commands/checkpoint-progress` |
| `session-cleanup` | Bash | `~/.factory/commands/session-cleanup` |
| `validate-hw-env` | Bash | `~/.factory/commands/validate-hw-env` |

#### Concrete examples

**AI-powered commit** (in a Droid session):

```
you> /autocommit
droid> Changes detected:
         M src/auth/middleware.ts
         M src/auth/middleware.test.ts
         A src/auth/rate-limiter.ts

       Proposed: feat(auth): add rate limiting middleware with per-IP tracking

       Commit with this message? (confirm in chat)
you> yes
droid> Committed: a1b2c3d feat(auth): add rate limiting middleware with per-IP tracking
```

**Manual commit** (from your terminal, no Droid session needed):

```bash
~/.factory/commands/commit-manual feat auth "add rate limiting middleware"
# Output: feat(auth): add rate limiting middleware
# Ready to commit with message:
#   feat(auth): add rate limiting middleware
# Create commit? (y/N)
```

**Quick checkpoint before a risky operation**:

```bash
~/.factory/commands/checkpoint-progress
# === Progress Checkpoint ===
# Project: /Volumes/workspace/catalyst-rcm-dashboard-bot
# Changes to checkpoint:
#   Modified files: src/auth/middleware.ts, src/auth/rate-limiter.ts
# Checkpoint created: d4e5f6a
# Pushed to remote: feat/auth-hardening
# === Checkpoint Complete ===
```

### Skills (Development Standards)

Skills are the Droid equivalent of `~/.claude/guidelines/`. They're reusable knowledge packages that Droid can reference during work.

**Where they live**: `~/.factory/skills/<skill-name>/SKILL.md`

**How to invoke them**: `/skill-name` in a Droid session, or reference them in conversation: "Follow the conventional-commits skill for this commit."

**Reference**: [Skills docs](https://docs.factory.ai/cli/configuration/skills)

| Skill | When It's Relevant |
|---|---|
| `conventional-commits` | Every git commit |
| `shell-scripts` | Writing or editing `*.sh`, `*.bash`, `Makefile` |
| `session-safety` | Working on hardware systems with NPU/GPU devices |
| `ai-patterns` | Building LLM integrations (`*.py`, `*.ts` with AI/LLM imports) |
| `readme-documentation` | Creating or updating `*.md` documentation |
| `project-setup` | Bootstrapping a new project |
| `shell-escaping` | Complex shell commands, Docker invocations, CI scripts |
| `c4-diagramming` | PlantUML architecture diagrams |
| `markdown-formatting` | Any markdown content generation |

#### Concrete examples

**Referencing a skill in conversation**:

```
you> Write a deployment script following the shell-scripts skill
droid> [reads ~/.factory/skills/shell-scripts/SKILL.md]
       [writes script with set -euo pipefail, SCRIPT_DIR detection, cleanup trap, etc.]
```

**Using skills implicitly** — Droid can discover and apply relevant skills based on context. If you ask it to write a commit message, it may check `conventional-commits`. You can also be explicit:

```
you> Commit these changes. Use the conventional-commits skill.
droid> feat(api): add tenant isolation check on /reports endpoint
```

### GitHub Actions Workflows

These are templates you copy into your projects' `.github/workflows/` directories.

#### PR Review Automation

Every pull request gets an automated Droid review based on your `.droid.yaml` rules.

**Setup for a project** (e.g., `catalyst-rcm-dashboard-bot`):

```bash
# 1. Install the project template (creates .droid.yaml)
./install.sh /Volumes/workspace/catalyst-rcm-dashboard-bot

# 2. Copy the workflow
mkdir -p /Volumes/workspace/catalyst-rcm-dashboard-bot/.github/workflows
cp workflows/droid-pr-review.yml \
   /Volumes/workspace/catalyst-rcm-dashboard-bot/.github/workflows/

# 3. Add your Factory API key as a GitHub secret
#    Go to: repo Settings > Secrets > Actions > New repository secret
#    Name: FACTORY_API_KEY
#    Value: (your key from https://app.factory.ai/settings)

# 4. Commit and push
cd /Volumes/workspace/catalyst-rcm-dashboard-bot
git add .droid.yaml .github/workflows/droid-pr-review.yml
git commit -m "ci: add Droid PR review automation"
git push
```

Now every PR gets a review like:

```
Droid Review — 3 comments

src/auth/middleware.ts:42
  Missing null check on req.user.customerId before tenant validation.
  This could throw TypeError on unauthenticated requests that slip past
  the auth middleware.

docker-compose.yml:15
  Port 5432 is bound to 0.0.0.0. Bind to 127.0.0.1 to prevent
  direct database access from outside the host.

src/api/reports.ts:78
  Path traversal risk: customerId is used directly in the file path
  without validation. An attacker could use ../../etc/passwd.
```

#### Scheduled Audits

Weekly automated security and architecture audits that open GitHub issues.

```bash
# Copy the workflow
cp workflows/droid-scheduled-audit.yml \
   /Volumes/workspace/catalyst-rcm-dashboard-bot/.github/workflows/

# Create labels for the issues (one-time setup)
cd /Volumes/workspace/catalyst-rcm-dashboard-bot
gh label create security --color d73a4a --description "Security findings"
gh label create architecture --color 0075ca --description "Architecture review findings"
gh label create automated-audit --color e4e669 --description "Generated by Droid"

# You can also trigger manually:
gh workflow run "Droid Scheduled Audit" --field audit_type=security
```

## Session Lifecycle (Without Hooks)

Claude Code has `SessionStart` and `Stop` hooks that fire automatically. Droid doesn't have lifecycle hooks, so the workflow is manual but follows the same pattern:

```
┌─────────────────────────────────────────────────┐
│  Claude Code (automatic)    Droid (manual)       │
│                                                   │
│  [SessionStart hook]        /session-init         │
│       ↓                          ↓                │
│  /lets-go                   (built into droid)    │
│       ↓                          ↓                │
│  [work]                     [work]                │
│       ↓                          ↓                │
│  [Stop hook reminder]       /session-logger       │
│       ↓                          ↓                │
│  /session-logger            /handoff              │
│  /handoff                                         │
└─────────────────────────────────────────────────┘
```

**Typical session**:

```bash
cd /Volumes/workspace/my-project
droid
```

```
you> /session-init
droid> [loads handoff, syncs git, reports status, suggests next steps]

you> [... do your work ...]

you> /session-logger
droid> [saves summary to ~/.factory/logs/2026-03-06-1700-topic.md]
       Reminder: Run /handoff if you're stopping for the day.

you> /handoff
droid> [saves continuation prompt to ~/.factory/logs/handoff-2026-03-06-1705.md]
```

## Overriding Configuration

### Override a global droid for one project

Create a file with the same name in the project's `.factory/droids/`:

```bash
# Example: customize the architect droid for a Python-only project
cat > /Volumes/workspace/my-python-project/.factory/droids/architect.md << 'EOF'
---
name: "architect"
description: "Python-focused architecture review"
model: "claude-opus-4-6"
tools: ["read", "execute"]
---

# Architecture Review (Python Focus)

Same as the global architect droid, but skip JavaScript/TypeScript checks.
Focus on:
- Python packaging (pyproject.toml, setup.cfg)
- FastAPI/Django patterns
- Type hints coverage (mypy strict)
- Test coverage with pytest
EOF
```

### Override global settings

Edit `~/.factory/settings.json` directly — it's a copy, not a symlink:

```bash
# Switch default model to Sonnet for faster responses
jq '.model = "claude-sonnet-4-6"' ~/.factory/settings.json > /tmp/s.json \
  && mv /tmp/s.json ~/.factory/settings.json

# Or change autonomy level
jq '.autonomy = "auto-medium"' ~/.factory/settings.json > /tmp/s.json \
  && mv /tmp/s.json ~/.factory/settings.json
```

You can also use Droid's built-in settings command: `/settings`

### Add MCP servers

Edit `~/.factory/mcp.json` to connect Droid to external tools. See the [MCP integration docs](https://docs.factory.ai/cli/configuration/mcp) for the full list of 40+ pre-configured servers.

```json
{
  "servers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_..."
      }
    }
  }
}
```

## Directory Structure

```
dot-droid/
├── README.md                              # This file
├── CLAUDE.md                              # For working on this repo with Claude Code
├── install.sh                             # Global and project installer
├── .gitignore
│
├── global/                                # THE DELIVERABLE — ~/.factory/ config
│   ├── settings.json                      # Model, autonomy, allowlists
│   ├── mcp.json                           # MCP server integrations
│   ├── droids/                            # 7 custom subagents
│   │   ├── architect.md
│   │   ├── session-init.md
│   │   ├── session-logger.md
│   │   ├── handoff.md
│   │   ├── session-miner.md
│   │   ├── editorial.md
│   │   └── security-auditor.md
│   ├── commands/                          # 5 slash commands / scripts
│   │   ├── autocommit.md
│   │   ├── commit-manual                  # bash
│   │   ├── checkpoint-progress            # bash
│   │   ├── session-cleanup                # bash
│   │   └── validate-hw-env               # bash
│   └── skills/                            # 9 reusable skill packages
│       ├── shell-scripts/SKILL.md
│       ├── conventional-commits/SKILL.md
│       ├── readme-documentation/SKILL.md
│       ├── session-safety/SKILL.md
│       ├── ai-patterns/SKILL.md
│       ├── project-setup/SKILL.md
│       ├── shell-escaping/SKILL.md
│       ├── c4-diagramming/SKILL.md
│       └── markdown-formatting/SKILL.md
│
├── project/                               # Per-project template
│   ├── .droid.yaml                        # PR review config
│   └── .factory/droids/.gitkeep
│
├── workflows/                             # GitHub Actions templates
│   ├── droid-pr-review.yml
│   ├── droid-scheduled-audit.yml
│   └── README.md
│
└── docs/
    ├── concept-mapping.md                 # 3-way mapping: Claude Code / Copilot / Droid
    └── limitations.md                     # What can't be ported + workarounds
```

## Key Differences from Claude Code

| What | Claude Code | Droid |
|---|---|---|
| Global config | `~/.claude/` (automatic) | `~/.factory/` (automatic) |
| Start a session | `claude` | `droid` |
| Slash commands | `/lets-go` | `/session-init` |
| Guidelines | `~/.claude/guidelines/*.md` (manual reference) | `~/.factory/skills/*/SKILL.md` ([docs](https://docs.factory.ai/cli/configuration/skills)) |
| Subagents | Agent tool (built-in) | Custom droids ([docs](https://docs.factory.ai/cli/configuration/custom-droids)) |
| Lifecycle hooks | SessionStart, Stop (automatic) | None — use `/session-init` manually |
| Auto-memory | Built-in per-project memory | Not available |
| Plan mode | Built-in read-only exploration | Not available (ask Droid to "plan first") |
| Multi-model | Claude only | Any provider via BYOK ([docs](https://docs.factory.ai/cli/configuration/settings)) |
| CI/CD | None | GitHub Actions workflows |
| Permissions | Fine-grained allow/deny (189 rules) | `commandAllowlist`/`commandDenylist` globs |

See [docs/concept-mapping.md](docs/concept-mapping.md) for the full 3-way mapping and [docs/limitations.md](docs/limitations.md) for detailed workarounds.

## Related Resources

- [Factory.AI Documentation](https://docs.factory.ai/)
- [Droid CLI Quickstart](https://docs.factory.ai/cli/getting-started/quickstart)
- [Custom Droids](https://docs.factory.ai/cli/configuration/custom-droids)
- [Skills](https://docs.factory.ai/cli/configuration/skills)
- [Settings](https://docs.factory.ai/cli/configuration/settings)
- [MCP Integrations](https://docs.factory.ai/cli/configuration/mcp)
- [.droid.yaml Configuration](https://docs.factory.ai/onboarding/configuring-your-factory/droid-yaml-configuration)

## Version History

- 2026-03-06: Initial creation — ported from `~/.claude/` and `dot-copilot`
