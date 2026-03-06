# Limitations: What Can't Be Ported to Droid

This document describes Claude Code features that have no direct Droid equivalent, along with concrete workarounds.

## No Session Lifecycle Hooks

**Claude Code**: `SessionStart` and `Stop` hooks fire automatically via `~/.claude/settings.json`. The `SessionStart` hook runs `load-handoff-context.sh` which finds the most recent `handoff-*.md` and injects it as context. The `Stop` hook runs `session-end-reminder.sh` which checks if 3+ files changed and reminds you to log/handoff.

**Droid**: No lifecycle hook system. Nothing runs automatically when you start or end a session.

**Workaround**: Run `/session-init` at the start of every session. It does the same work as the SessionStart hook (finds and loads recent handoff) plus the `/lets-go` command (syncs git, reviews project docs):

```
you> /session-init
droid> Found handoff: ~/.factory/logs/handoff-2026-03-05-1430.md
       Branch main is up to date with origin.
       ...
```

For session end, `/session-logger` reminds you about `/handoff` and vice versa:

```
you> /session-logger
droid> Session log saved to ~/.factory/logs/2026-03-06-1700-auth.md
       Reminder: You changed 8 files. Run /handoff before closing.
```

**What you lose**: The automation. In Claude Code you get nudged automatically. In Droid you have to remember to start with `/session-init` and end with `/session-logger` + `/handoff`. Muscle memory from Claude Code helps, but there's no safety net if you forget.

## No Auto-Memory

**Claude Code**: Each project gets a persistent auto-memory directory (`~/.claude/projects/*/memory/MEMORY.md`) where Claude automatically records patterns and insights across sessions. You never have to tell it to remember things — it just does.

**Droid**: No equivalent.

**Workaround**: Maintain a `MEMORY.md` manually in your project. Use the `session-miner` droid periodically to identify patterns worth recording:

```
you> /session-miner
droid> Analyzed 12 sessions over 30 days.
       Reinforced patterns (appeared 3+ times):
       - Always run tenant isolation tests after auth changes
       - FastAPI dependency injection order matters for test fixtures
       Recommend adding these to project MEMORY.md.
```

## No Plan Mode

**Claude Code**: Has a dedicated plan mode (`/plan` or triggered by the system) where Claude explores the codebase read-only, designs an approach, writes a plan file, and waits for your approval before making any changes.

**Droid**: No structured planning mode with enforced read-only constraints.

**Workaround**: Ask Droid explicitly:

```
you> I want to refactor the auth middleware. Don't make any changes yet —
     just analyze the codebase and propose a plan.
droid> [reads files, proposes plan]

you> Looks good. Go ahead and implement step 1.
```

Or use the `architect` droid for structured analysis:

```
you> /architect
droid> [comprehensive read-only analysis with recommendations]
```

**What you lose**: The enforced read-only guarantee. In Claude Code, plan mode physically prevents edits. In Droid, you're trusting the instruction — Droid *could* still make changes if it misinterprets your intent.

## Different Permissions Model

**Claude Code**: Fine-grained `allow`/`deny` lists in `settings.json` controlling exactly which tools and commands can be executed. The user's config has 189 rules like `Bash(git push:*)`, `Bash(docker compose:*)`, `Read(//Users/scottfrancis/.claude/**)`.

**Droid**: Simpler `commandAllowlist`/`commandDenylist` with glob patterns in [`settings.json`](https://docs.factory.ai/cli/configuration/settings):

```json
{
  "commandAllowlist": ["git *", "docker *", "npm *"],
  "commandDenylist": ["rm -rf /"]
}
```

**Impact**: Less granular control. You can allow `git *` but you can't specifically allow `git push` while denying `git push --force`. The autonomy setting (`normal`, `auto-low`, `auto-medium`, `auto-high`) provides coarser control over what Droid does without asking.

## No $ARGUMENTS Variable

**Claude Code**: Commands receive structured arguments via `$ARGUMENTS`. Example: `/session-logger performance` passes "performance" as `$ARGUMENTS`, and the command template interpolates it into the output filename.

**Droid**: No structured argument passing. Arguments come through natural language in the conversation.

**Concrete difference**:

```
# Claude Code — structured, one shot
/session-logger performance

# Droid — conversational
/session-logger
> Topic for this log: performance
```

**Impact**: Slightly more conversational friction. But droids can parse natural language well enough that "log this session, topic is performance" works fine.

## Settings Files Are Copied, Not Symlinked

**Issue**: `install.sh --global` copies `settings.json` and `mcp.json` rather than symlinking them, because these files contain machine-specific config (model preferences, API keys, MCP server paths).

**Impact**: If you update `dot-droid/global/settings.json` with new allowlist rules, existing installs won't pick up the change.

**Workaround**: Re-run `./install.sh --global` — it skips existing files, so your customizations are safe. To force-update settings, delete the file first:

```bash
rm ~/.factory/settings.json
./install.sh --global
# Then re-apply your customizations
```

Droids, commands, and skills are symlinked and auto-propagate via `git pull`.

## No Skill Auto-Application by File Path

**Claude Code**: Guidelines are manually referenced in `CLAUDE.md`:
```markdown
Follow ~/.claude/guidelines/shell-scripts.md for all bash scripts.
```

**Copilot**: Instructions auto-apply via `applyTo` glob patterns — the `shell-scripts` instruction fires automatically when editing `*.sh` files.

**Droid**: Skills are available but not automatically applied based on file context. They must be invoked (`/shell-scripts`) or referenced in conversation ("follow the shell-scripts skill").

**Workaround**: Encode critical rules directly in your droid instructions. For example, the `session-logger` droid includes conventional commit references inline rather than delegating to the skill. For project-specific enforcement, add instructions to `.droid.yaml`:

```yaml
guidelines:
  - path: "**/*.sh"
    instructions: "Follow the shell-scripts skill: set -euo pipefail, SCRIPT_DIR detection, cleanup traps."
```

This way `.droid.yaml` provides the auto-application that skills alone don't.

## Session Logs Are Separate

**Decision**: Droid uses `~/.factory/logs/` instead of sharing `.claude/session-logs/`.

**Impact**: A handoff file created in Claude Code (`~/.factory/logs/handoff-*.md` vs `.claude/session-logs/handoff-*.md`) won't automatically be found by the other tool.

**Workaround**: The `session-init` droid checks both locations:

```
you> /session-init
droid> Checking ~/.factory/logs/ for recent handoffs... none found.
       Checking .claude/session-logs/ for recent handoffs...
       Found: .claude/session-logs/handoff-2026-03-05-1430.md (from Claude Code)
       Loading context...
```

If you switch tools frequently, you could symlink one directory to the other, but the current design keeps them separate to avoid conflicts.
