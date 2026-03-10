# CLAUDE.md

This file provides guidance to Claude Code when working on this repository.

## Project Purpose

This repository contains portable Factory.AI Droid configuration files — the Droid equivalent of `~/.claude/`. It provides global droids, commands, skills, and settings that get installed to `~/.factory/` and per-project `.factory/` directories.

## Repository Structure

- `.factory/` — The deliverable: symlinked to `~/.factory/` on install
  - `settings.json.example` — Model, autonomy, allowlists/denylists template (gitignored locally)
  - `mcp.json.example` — MCP server integrations template (gitignored locally)
  - `droids/` — Custom subagents (lets-go, arch-review, etc.)
  - `commands/` — Slash commands (autocommit, commit-manual, etc.)
  - `skills/` — Reusable skill packages (shell-scripts, conventional-commits, etc.)
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

- Follow `~/.claude/guidelines/conventional-commits.md` for commit messages
- Follow `~/.claude/guidelines/shell-scripts.md` for any bash scripts
- When porting content from `~/.claude/`, preserve the intent while adapting to Droid's format
- Droids use YAML frontmatter with `name`, `description`, `model`, `tools`
- Skills use YAML frontmatter with `name`, `description`

## Branch Policy

Work on feature branches. Main is the stable configuration.
