# GitHub Copilot → Droid Migration Guide

For engineers who live in Copilot and Copilot CLI and want to add a Droid workflow alongside it — or replace it where Droid is stronger.

---

## The Mental Model Shift

Copilot is editor-first: inline completions, a chat sidebar, and agents you select from a dropdown. Instructions auto-apply by file glob. Lifecycle hooks fire without you thinking about them.

Droid is session-first: a CLI agent you invoke for complex, agentic work. Nothing auto-applies — you invoke droids and skills explicitly, or bake rules into `.droid.yaml` for automatic PR review. The tradeoff is more control over what runs and when, at the cost of more intentional invocation.

**Use both.** Copilot handles inline completions and quick questions. Droid handles session management, architecture review, security audits, and CI automation.

---

## Installation

### Step 1: Install the Droid CLI

```bash
curl -fsSL https://app.factory.ai/cli | sh
# or
brew install factory-ai/tap/droid
```

Authenticate on first run:

```bash
droid
# opens browser for auth — creates ~/.factory/config.json
```

### Step 2: Clone dot-droid

```bash
cd /path/to/your/workspace
git clone https://github.com/scottfrancis/dot-droid.git
cd dot-droid
```

### Step 3: Run global install

```bash
./install.sh --global
```

This creates a single symlink:

```
~/.factory  →  /path/to/dot-droid/.factory/
```

Everything under `~/.factory/` is now live from the repo. `git pull` in `dot-droid` propagates all droid, skill, and command updates immediately — no reinstall needed.

The installer also copies two template files to your machine-local config (gitignored):

| File | Purpose |
|---|---|
| `~/.factory/settings.json` | Model, autonomy, command allowlist |
| `~/.factory/mcp.json` | MCP server integrations |

Edit these freely. They are never committed.

### Step 4: Configure settings

Open `~/.factory/settings.json` and adjust:

```json
{
  "model": "claude-opus-4-6",
  "autonomy": "normal",
  "commandAllowlist": [
    "git *", "ls *", "find *",
    "npm install *", "npm ci *", "npx *",
    "python3 *", "pip3 *", "pytest *",
    "docker *", "docker-compose *",
    "curl *", "gh *", "aws *"
  ],
  "commandDenylist": [
    "rm -rf /", "rm -rf ~"
  ]
}
```

**Autonomy levels**: `normal` (asks before most actions), `auto-low`, `auto-medium`, `auto-high`. Start with `normal` until you trust the workflow.

**Allowlist note**: Unlike Copilot's sandboxed VS Code environment, Droid runs as your shell user. The `commandDenylist` is your safety net — keep `rm -rf /` and `rm -rf ~` in there.

### Step 5: Install per-project template (optional)

```bash
./install.sh /path/to/your/project
```

This copies `.droid.yaml` into the project root and creates a local `.factory/` overlay for project-specific droid overrides and session logs. The logs directory (`.factory/logs/`) is gitignored.

---

## What's Enabled After Global Install

### Droids (`~/.factory/droids/`)

Droids are the Copilot agent equivalent. Invoke with `/droid-name` in the Droid CLI.

| Droid | Copilot Agent Equivalent | What It Does |
|---|---|---|
| `/lets-go` | `lets-go` agent | Session init: loads handoff, git sync, project overview |
| `/pickup` | *(no equivalent)* | Post-context-clear resume — loads most recent handoff only |
| `/session-logger` | `session-logger` agent | Documents what happened, decisions made, outcomes |
| `/handoff` | `handoff` agent | Generates continuation prompt for next session |
| `/arch-review` | `arch-review` agent | Principal Architect review: AWS Well-Architected, SOLID, security |
| `/security-audit` | *(no equivalent in Copilot)* | Breach-driven security audit |
| `/doc-review` | *(no equivalent)* | Audits documentation for accuracy, DRY, clarity |
| `/editorial-review` | *(no equivalent)* | Audits prose for AI tells; style-matched voice |
| `/mine-sessions` | `mine-sessions` agent | Analyzes session logs for patterns and improvements |
| `/extract-adr` | *(no equivalent)* | Extracts architectural decisions into ADR format |

### Skills (`~/.factory/skills/`)

Skills are the Copilot instructions equivalent — but **not auto-applied by file glob**. You invoke them explicitly or reference them in `.droid.yaml` (see below).

| Skill | Invoke As | Copilot Instruction Equivalent |
|---|---|---|
| Shell scripts | `/shell-scripts` | `shell-scripts.instructions.md` (applyTo: `**/*.sh`) |
| Conventional commits | `/conventional-commits` | `conventional-commits.instructions.md` |
| README documentation | `/readme-documentation` | `readme-documentation.instructions.md` |
| Security hardening | `/security-hardening` | *(no equivalent)* |
| AI patterns | `/ai-patterns` | *(no equivalent)* |
| Prose style | `/prose-style` | *(no equivalent)* |
| Prototype hygiene | `/prototype-hygiene` | *(no equivalent)* |
| Markdown formatting | `/markdown-formatting` | `markdown-formatting.instructions.md` |
| Shell escaping | `/shell-escaping` | *(no equivalent)* |
| C4 diagramming | `/c4-diagramming` | `c4-diagramming.instructions.md` |
| Session safety | `/session-safety` | `session-safety.instructions.md` |
| Project setup | `/project-setup` | `project-setup.instructions.md` |

### Commands (`~/.factory/commands/`)

| Command | Copilot Equivalent | How to Run |
|---|---|---|
| `autocommit` | `autocommit` agent | `/autocommit` in Droid CLI, or `~/.factory/commands/autocommit` from terminal |
| `checkpoint-progress` | `checkpoint-progress` agent | Run directly from terminal |
| `commit-manual` | *(no equivalent)* | Run directly from terminal |
| `session-cleanup` | *(no equivalent)* | Run directly from terminal |
| `validate-hw-env` | *(no equivalent)* | Run directly from terminal (hardware dev only) |

---

## The Biggest Difference: Skills Don't Auto-Apply

In Copilot, this fires automatically when you edit a `.sh` file:

```yaml
# .github/instructions/shell-scripts.instructions.md
---
applyTo: "**/*.sh"
---
```

In Droid, skills are opt-in. You either invoke explicitly:

```
you> /shell-scripts
```

Or you encode enforcement in `.droid.yaml` so it applies during PR review:

```yaml
# .droid.yaml
reviews:
  guidelines:
    - path: "**/*.sh"
      instructions: "Follow the shell-scripts skill: set -euo pipefail, SCRIPT_DIR detection, cleanup traps."
```

The `.droid.yaml` approach is the right substitute for `applyTo` — it gates rules at PR review time rather than at edit time. For rules you want Droid to apply during a session (not just PR review), invoke the skill at session start or reference it when assigning a task.

**Practical pattern**: Start a task with skill context:

```
you> I'm writing a deployment script. Follow the shell-scripts skill.
# or
you> /shell-scripts
     Now create deploy.sh that...
```

---

## Session Workflow Comparison

### Copilot workflow (automatic)

```
[VS Code opens] → sessionStart hook fires → handoff context injected automatically
[Work happens] → instructions auto-apply by file type
[VS Code closes] → sessionEnd hook fires → reminder to log/handoff
```

### Droid workflow (manual, intentional)

```
droid> /lets-go          # git sync + load recent handoff + project overview
[Work happens]           # invoke skills as needed
droid> /session-logger   # document outcomes (reminds you about /handoff)
droid> /handoff          # write continuation prompt for next session
```

**What you lose**: The automation. No hook fires when you open or close a session. `/lets-go` and `/session-logger` + `/handoff` are the manual equivalents — you have to remember the cycle.

**What you gain**: The cycle is explicit. Every session is deliberate. `/pickup` gives you a fast resume path after context clears without the full `/lets-go` overhead.

---

## PR Review: Droid + Copilot Coexistence

Both tools can review PRs. To avoid duplicate comments:

**Option A — Droid only for PR review:**
1. Disable Copilot PR review in your repo settings
2. Copy `workflows/droid-pr-review.yml` to `.github/workflows/`
3. Add `FACTORY_API_KEY` as a GitHub secret
4. Configure `.droid.yaml` guidelines for your stack

```bash
# Manual trigger
gh workflow run "Droid PR Review" --field pr_number=42
```

**Option B — Copilot for inline, Droid for scheduled audits:**
1. Keep Copilot PR review active
2. Deploy only `workflows/droid-scheduled-audit.yml` (weekly security/arch audits)
3. Droid creates GitHub issues; Copilot handles inline PR comments

```bash
# Trigger an audit manually
gh workflow run "Droid Scheduled Audit" --field audit_type=security
```

Option B is the lower-friction starting point if you're already happy with Copilot PR review.

---

## Permissions: Copilot vs Droid

| Aspect | Copilot | Droid |
|---|---|---|
| Execution context | Sandboxed VS Code extension | Your shell, your user |
| Per-tool control | `tools` array in agent frontmatter | `commandAllowlist`/`commandDenylist` in `settings.json` |
| Granularity | Tool-level (readFile, executeCommand, etc.) | Command-prefix glob (`git *`, `docker *`) |
| Force-push protection | N/A | Add `"git push --force*"` to `commandDenylist` |

Droid's model is coarser. You can allow `git *` but you can't allow `git push` while blocking `git push --force` — that requires adding the force pattern to the denylist explicitly.

---

## MCP Servers

Copilot has no MCP equivalent. This is Droid's biggest exclusive capability. Add servers to `~/.factory/mcp.json`:

```json
{
  "servers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/project"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost/mydb"]
    }
  }
}
```

MCP config is machine-local and gitignored. If you work on a team, share server names and configuration patterns in `~/.factory/mcp.json.example` (committed) so teammates know what to configure locally.

---

## Team Rollout: Sharing Defaults

`settings.json` and `mcp.json` are intentionally gitignored. For teams:

1. **Maintain `settings.json.example`** in the repo with safe team defaults (committed)
2. **Document MCP servers** in `mcp.json.example` with paths as comments
3. **Onboarding**: `cp ~/.factory/settings.json.example ~/.factory/settings.json` and edit

```bash
# Check if your local settings have drifted from the team template
diff ~/.factory/settings.json ~/.factory/settings.json.example
```

For per-project guardrails (code review rules, file-specific checks), put them in `.droid.yaml` — this file is committed and applies to everyone.

---

## Quick Reference: Copilot → Droid Cheat Sheet

| You used to... | Now do this |
|---|---|
| Open VS Code, hooks auto-inject context | `droid` → `/lets-go` |
| Select agent from dropdown | Type `/agent-name` in Droid CLI |
| `applyTo: "**/*.sh"` auto-fires | `/shell-scripts` or add to `.droid.yaml` guidelines |
| `copilot-instructions.md` for global rules | Encode in droid frontmatter or `.droid.yaml` |
| Copilot PR review (automatic) | `droid-pr-review.yml` workflow + `FACTORY_API_KEY` secret |
| No scheduled audit | `droid-scheduled-audit.yml` — weekly security/arch issues |
| sessionEnd hook reminds you to log | `/session-logger` — it reminds you about `/handoff` |
| Context clears, hook reloads handoff | `/pickup` |
| No MCP | `~/.factory/mcp.json` |
