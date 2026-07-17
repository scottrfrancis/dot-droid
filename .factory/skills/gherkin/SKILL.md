---
name: gherkin
description: >
  Generate draft Gherkin scenarios from a requirement description or FR-### ID.
  Use when writing acceptance criteria, converting requirements to feature files,
  or expanding scenario coverage. Invoke with /gherkin or let the Droid use it
  when requirements are being discussed.
---

# Gherkin Scenario Generator

## When to Use

- Converting a requirement into testable acceptance criteria
- Expanding coverage for an existing feature file
- Starting a new feature file from a pain point or user story
- Bridging discovery findings into executable specifications

## Instructions

### 1. Learn the project conventions

Read existing feature files to establish patterns. Check these locations in order:

- `docs/requirements/*.feature`
- `docs/specs/**/*.feature`
- `docs/internal/features/**/*.feature`

From existing files, extract:
- **Tag patterns**: `@fr-###`, `@mvp`, `@future-*`, `@draft`, milestone tags
- **Persona names**: Used in Given steps (e.g., "the Vantage Operator", "the Field Operator")
- **Domain vocabulary**: Consistent terminology for When/Then steps
- **Background patterns**: Common preconditions used across features

If no existing feature files are found, use generic BDD conventions.

### 2. Locate the requirement

If the input references an FR-### ID, search for the requirement definition in:
- `docs/design/SRS.md`
- `docs/deliverables/D1.7*`
- `docs/deliverables/*Requirements*`

If the input is a plain-language description, use it directly.

### 3. Generate scenarios

For each requirement, generate:

**Feature header**:
```gherkin
Feature: [Descriptive name]
  As a [persona from project conventions]
  I want [capability addressing the requirement]
  So that [business value / pain point resolution]
```

**Background** (if applicable):
```gherkin
  Background:
    Given [common precondition for all scenarios in this feature]
```

**Scenarios** (generate 3-6):
1. **Happy path** — the primary success case
2. **Variation** — a different valid input or path
3. **Edge case** — boundary condition or unusual but valid input
4. **Error/validation** — invalid input, missing data, or permission denied
5. **State transition** (if applicable) — system state changes
6. **Authorization** (if applicable) — role-based access

### 4. Apply tags

Every scenario MUST have:
- `@fr-X.X` — the requirement ID (from input or assigned next available)
- `@draft` — marks as unreviewed
- Milestone tag (`@mvp` or `@future-*`) — infer from requirement context, default to `@mvp`
- Source tag if from an interview: `@source-[name]`

### 5. Use declarative steps

Write steps that describe WHAT happens, not HOW:

**Good**:
```gherkin
Given the operator is viewing the alarm dashboard
When a flood event with 47 alarms is detected
Then the alarms are grouped into a single event card
```

**Bad**:
```gherkin
Given the user opens Chrome and navigates to localhost:3001
When the user clicks the refresh button
Then the user sees a card element with class "event-card"
```

### 6. Place the output

- If adding to an existing feature file, append scenarios after the last existing scenario
- If creating a new feature file, save to `docs/requirements/[topic]-draft.feature`
- Never modify scenarios that don't have the `@draft` tag

## Verification

After generating, confirm:
- [ ] All scenarios have `@fr-*` tags
- [ ] Feature file has Feature: header with As/I want/So that
- [ ] Steps use domain vocabulary consistent with existing features
- [ ] No duplicate scenarios with existing feature files
- [ ] Declarative steps throughout (no UI implementation details)
- [ ] Edge cases and error conditions are covered, not just happy paths

## Example Invocation

```
/gherkin FR-5.14: Event detail panel shows alarm count by type with severity breakdown
```

Or:

```
/gherkin When a power failure cascade occurs, operators need to see all 47 alarms
grouped into a single event with root cause hypothesis and recommended actions
```
