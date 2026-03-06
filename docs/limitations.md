# Limitations: What Can't Be Ported to Droid

This document describes Claude Code features that have no direct Droid equivalent, along with workarounds.

## No Session Lifecycle Hooks

**Claude Code**: `SessionStart` and `Stop` hooks fire automatically. The `SessionStart` hook injects recent handoff context; the `Stop` hook reminds about session logging.

**Droid**: No lifecycle hook system.

**Workaround**: The `session-init` droid includes handoff context loading as its first step. The `session-logger` and `handoff` droids include cross-reminders about each other. Users must manually invoke these instead of relying on automatic triggers.

## No Auto-Memory

**Claude Code**: Has a persistent auto-memory directory where patterns and insights are recorded across sessions automatically.

**Droid**: No equivalent auto-memory system.

**Workaround**: Use session logs and handoff files for continuity. Maintain project-specific context files manually.

## No Plan Mode

**Claude Code**: Has a dedicated plan mode with enforced read-only exploration and user approval gates.

**Droid**: No structured planning mode.

**Workaround**: Ask Droid to "analyze and plan before making changes" or use the `architect` droid for structured analysis.

## Different Permissions Model

**Claude Code**: Fine-grained `allow`/`deny` lists controlling which tools and commands can be executed (189 rules in the user's config).

**Droid**: Simpler `commandAllowlist`/`commandDenylist` with glob patterns.

**Impact**: Less granular control. The allowlist approach covers most cases but can't restrict by argument patterns (e.g., `Bash(git push:*)` specifically).

## No $ARGUMENTS Variable

**Claude Code**: Commands receive arguments via `$ARGUMENTS`.

**Droid**: Commands and droids receive context through natural language in the conversation.

**Workaround**: Droid instructions describe expected inputs. Users provide arguments naturally: "Run session-logger with topic: performance."

## Settings Files Are Copied, Not Symlinked

**Issue**: `settings.json` and `mcp.json` are copied during global install rather than symlinked, because users need to customize model selection, API keys, and MCP servers per-machine.

**Impact**: Updates to `dot-droid/global/settings.json` don't automatically propagate. Users must manually update or re-run the installer.

**Workaround**: The installer skips existing files, so re-running is safe. Droids, commands, and skills are symlinked and do auto-propagate.

## No Skill Auto-Application by File Path

**Claude Code**: Guidelines are manually referenced in CLAUDE.md.

**Copilot**: Instructions auto-apply via `applyTo` glob patterns.

**Droid**: Skills are available but not automatically applied based on file context. They must be invoked or referenced.

**Workaround**: Encode critical guidelines (conventional commits, session safety) directly in droid instructions rather than relying on skill auto-invocation.

## Session Logs Are Separate

**Decision**: Droid uses `~/.factory/logs/` instead of sharing `.claude/session-logs/`.

**Impact**: No cross-tool session continuity. A handoff created in Claude Code won't be automatically found by the Droid `session-init` droid.

**Workaround**: The `session-init` droid checks both `~/.factory/logs/` and `.claude/session-logs/` for handoff files, providing some cross-tool continuity.
