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
<\!-- central-ops-knowledge: begin -->
## Central Ops Knowledge (shared doctrine — all my AI tools)

I maintain ONE central, authoritative **ops-knowledge state** for my homelab/home: **dynamic**
(live, current, queryable by every human and AI on the LAN) and **archival** (durable,
portable, hand-off-able to anyone taking over anything). It lives in the **HomeAssistant repo**
(`/Volumes/workspace/HomeAssistant/` → `home-ops/` OKF bundle + `wiki/`), is surfaced
live to agents via the read-only **`kb-mcp` filesystem MCP** (`mini.local:8092`, tools
`search`/`read_file`/`list_dir`; registered in **Hazel**/OpenWebUI and reusable by any MCP
client) and to humans via **`kb-static`** browse (`mini.local:8090`), and kept current by the
`tools/*-scan.sh` self-tracking probes. (Ingesting the bundle into the **Librarian RAG** is on
indefinite hold — the MCP reads markdown live, no re-index.) Full doctrine:
`~/.claude/guidelines/central-ops-knowledge.md`.

Operating rules for every agent (Claude, OpenCode, Codex, Cursor, Droid, Copilot…):
1. **Consult before acting on infrastructure** — before stopping/changing a service, host, or
   config, check the knowledge base for "what is this and *why*." Stale assumptions cause outages.
2. **Write back** — when you learn or change something about the ops state, record or flag it so
   it stays current. Session-only knowledge is lost.
3. **OKF form** — plain markdown + YAML, **no secrets** (pointers only), conformant for any tool.
4. **Local-first / WAN-tolerant** — prefer local LLM/files/Kiwix; must work with the internet down.
5. **Respect boundaries** — household surfaces LAN-only; don't touch non-Scott tailnet hosts.
<\!-- central-ops-knowledge: end -->
