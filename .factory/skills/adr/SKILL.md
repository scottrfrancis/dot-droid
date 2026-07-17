---
name: adr
description: >
  The canonical Architecture Decision Record convention — location, numbering,
  status lifecycle, and template. Use when writing, extracting, or reviewing an
  ADR so every decision record has the same shape. Invoke with /adr, or let the
  Droid apply it whenever an ADR is created or edited. The extract-adr droid and
  the spec-driven toolkit (constitution, design-review, trace-check) all follow it.
---

# Architecture Decision Records (ADRs)

The single ADR convention for the project. Every ADR follows it.

## Location & filename

- **Canonical directory:** `docs/decisions/`
- **Filename:** `ADR-NNNN-kebab-slug.md` — zero-padded 4-digit number + short kebab slug.
  Example: `docs/decisions/ADR-0007-postgres-over-dynamo.md`.
- **Legacy read path:** also *read* `docs/adr/` for back-compat; *write* new ADRs to
  `docs/decisions/`. If a project already uses `docs/adr/`, keep writing there — pick
  one per project, don't split.

## Numbering

- Sequential from `0001`, never reused, never renumbered — the number is a permanent ID.
- Next number = `max(existing) + 1`:
  `grep -rho 'ADR-[0-9]\{4\}' docs 2>/dev/null | sort -u | tail -1`.
- Superseding a decision creates a **new** ADR with a new number; it never edits the old.

## Status lifecycle

`Proposed` → `Accepted` → (`Deprecated` | `Superseded by ADR-NNNN`) — or `Rejected`.

- **Accepted** ADRs are **immutable** except for their Status line. Change your mind by
  writing a new ADR that supersedes the old (link both ways).

## Template (use verbatim)

```markdown
# ADR-NNNN: <short imperative title>

- **Status:** Proposed | Accepted | Rejected | Deprecated | Superseded by ADR-NNNN
- **Date:** YYYY-MM-DD
- **Deciders:** <who made the call>
- **Related requirements:** FR-###, FR-###   <!-- traceability; omit if none -->
- **Related ADRs:** ADR-NNNN (supersedes), ADR-NNNN (related)   <!-- omit if none -->

## Context

The forces at play: problem, constraints, what makes this decision necessary. Facts and
requirements, not the choice yet. If it traces to a requirement or an assumption
(ASSUMPTIONS-TRACKER A##), name it here.

## Decision

The choice, active voice: "We will …". One decision per ADR.

## Consequences

- **Positive:** what this enables or simplifies.
- **Negative:** what it costs, constrains, or risks.  <!-- required, never omit -->
- **Neutral:** follow-on work, things now locked in.

## Alternatives considered

Each realistic option and the one-line reason it lost.
```

## Rules that must hold

- One decision per ADR. Immutable once Accepted — supersede, don't rewrite.
- Consequences must include the negative ones; upside-only ADRs are incomplete.
- Link into `FR-###` traceability where the project uses it, so `trace-check` sees it.
- A decision record, not a design doc — keep it short, link out for detail.
