# CLAUDE.md

This file provides guidance to Claude Code when working on this repository.

## Project Purpose

This repository contains portable Factory.AI Droid configuration files — the Droid equivalent of `~/.claude/`. It provides global droids, commands, skills, and settings that get installed to `~/.factory/` and per-project `.factory/` directories.

## Repository Structure

- `.factory/` — The deliverable: symlinked to `~/.factory/` on install
  - `settings.json.example` — Model, autonomy, allowlists/denylists template (gitignored locally)
  - `mcp.json.example` — MCP server integrations template (gitignored locally)
  - `droids/` — Custom subagents (lets-go, arch-review, doc-review, extract-adr, etc.)
  - `commands/` — Slash commands (autocommit, commit-manual, etc.)
  - `skills/` — Reusable skill packages (shell-scripts, conventional-commits, prose-style, prototype-hygiene, security-hardening, etc.)
- `project/` — Per-project template (.droid.yaml + .factory/)
- `workflows/` — GitHub Actions templates for Droid automation
- `install.sh` — Installer for global and project config
- `docs/` — Concept mapping and limitations documentation

## Key Concepts

Each file maps to a Claude Code equivalent:

| This Repo | Claude Code Equivalent |
|---|---|
| `.factory/settings.json` | `~/.claude/settings.json` |
| `.factory/droids/*.md` | `~/.claude/commands/*.md` (complex commands) |
| `.factory/commands/*` | `~/.claude/commands/*` (simple/bash commands) |
| `.factory/skills/*/SKILL.md` | `~/.claude/guidelines/*.md` |

## Development Guidelines

This repository is standalone and **does not require Claude Code or `~/.claude/` to be installed**. All dev-workflow rules below have local copies in `.factory/skills/`. The `~/.claude/` paths are listed as optional fallbacks when Claude Code is available on the same machine.

- **Red-Green-Refactor TDD is REQUIRED for ALL code changes.** Always write a failing test first (RED), then the minimum production code to pass (GREEN), then refactor with tests green. No production code without a failing test. No retroactive tests. See `.factory/skills/testing/SKILL.md` for the full cycle, non-negotiable rules, and the (narrow) exceptions.
- Follow `.factory/skills/conventional-commits/SKILL.md` (fallback: `~/.claude/guidelines/conventional-commits.md`) for commit messages
- Follow `.factory/skills/shell-scripts/SKILL.md` (fallback: `~/.claude/guidelines/shell-scripts.md`) for any bash scripts
- When porting content from `~/.claude/` (only if installed), preserve the intent while adapting to Droid's format
- Droids use YAML frontmatter with `name`, `description`, `model`, `tools`
- Skills use YAML frontmatter with `name`, `description`

## Branch Policy

Work on feature branches. Main is the stable configuration.
