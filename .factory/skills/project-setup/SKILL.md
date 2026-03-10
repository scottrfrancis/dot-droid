---
name: "project-setup"
description: "Tiered checklist for bootstrapping new projects with appropriate infrastructure"
---

# Project Setup Guideline

Match infrastructure investment to project complexity and duration.

## Tier 1: Foundation (All Projects, ~5 minutes)

- [ ] Create `CLAUDE.md` or `AGENTS.md` at project root with: role definition, tone guidance, repository structure, key commands
- [ ] Create memory/context index file linking to key docs
- [ ] Create session logs directory for handoff context
- [ ] Verify global commands work
- [ ] Document branch policy if non-default

## Tier 2: Tracked Projects (~15 minutes)

Everything from Tier 1, plus:

- [ ] Create project-specific settings/permissions
- [ ] Set up session logs directory
- [ ] Add project-specific hooks or automation as needed
- [ ] Run session initialization to verify context loading
- [ ] For web applications: run security audit before first production deployment

## Tier 3: Domain-Specific Lifecycle (Incremental)

Everything from Tier 2, plus:

- [ ] Custom skills for repeating workflows (add when a workflow repeats 3+ times)
- [ ] Outcome tracking file if project has measurable cycles
- [ ] Pattern memory file for learned heuristics
- [ ] Validation hooks for data quality on critical files
- [ ] Domain-specific memory files

## When to Add Tier 3 Components

- **Custom skills**: Same multi-step workflow repeated 3+ times
- **Outcome tracking**: Project has a measurable feedback loop
- **Pattern memory**: Same lessons re-learned across sessions
- **Validation hooks**: Critical file has a required structure that's easy to break
