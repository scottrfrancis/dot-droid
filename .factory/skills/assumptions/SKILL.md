---
name: assumptions
description: >
  Format and track hypothesis-driven assumptions with if-true/if-false/fallback
  structure. Appends to the project's ASSUMPTIONS-TRACKER.md. Use when
  capturing assumptions from interviews, meetings, or design discussions.
  Invoke with /assumptions followed by the assumption text.
---

# Assumption Tracker

## When to Use

- After an interview surfaces an unvalidated belief
- During architecture discussions when a decision depends on an untested premise
- Before a meeting where you need to validate something
- When someone says "I think..." or "We assume..." or "It should be..."

## Instructions

### 1. Find the assumptions tracker

Search for the tracker file in order:
- `docs/discovery/ASSUMPTIONS-TRACKER.md`
- `docs/ASSUMPTIONS-TRACKER.md`
- `docs/discovery/assumptions.md`

If none exists, create `docs/discovery/ASSUMPTIONS-TRACKER.md` with a header and the first entry.

### 2. Determine the next ID

Read the existing tracker and find the highest A## number. The new assumption gets the next sequential number.

### 3. Structure the assumption

Transform the plain-language input into the hypothesis format:

```markdown
### A[##]: [Title — short, specific]

**Hypothesis**: [Precise testable statement]
**Validation Status**: PENDING
**Validation Method**: [How we will test this — meeting, measurement, prototype, document review]
**Impact if TRUE**: [What becomes possible, what path we take]
**Impact if FALSE**: [What breaks, what alternative path we need]
**Fallback**: [Plan C — what we do if we can't validate at all]
**Owner**: [TBD unless specified]
**Due Date**: [TBD unless specified]
**Source**: [Where this assumption came from — interview, meeting, design discussion]
```

### 4. Classify severity

Add a severity tag based on impact:
- **CRITICAL**: Blocks project direction (e.g., platform choice, deployment model)
- **HIGH**: Affects timeline or scope significantly
- **MEDIUM**: Affects design decisions but has workable alternatives
- **LOW**: Nice to validate but not blocking

### 5. Append to tracker

Add the new assumption to the end of the tracker file. Do not reorder existing entries.

### 6. Check for related assumptions

Scan existing assumptions for:
- **Duplicates**: Same hypothesis already tracked (skip, report as duplicate)
- **Dependencies**: New assumption depends on or conflicts with an existing one (note the relationship)
- **Clusters**: Multiple assumptions about the same system or decision (note the cluster)

## Verification

- [ ] Assumption has a testable hypothesis (not vague)
- [ ] Impact-if-true and impact-if-false describe different project paths
- [ ] Fallback plan exists (what if we can't validate at all?)
- [ ] No duplicate of an existing assumption
- [ ] Severity classification is reasonable

## Example

Input: `/assumptions MDP data latency is under 10 seconds`

Output appended to tracker:

```markdown
### A06: MDP Data Latency <10 Seconds

**Hypothesis**: The Modern Data Platform receives alarm data from SCADA with less than 10-second end-to-end latency.
**Validation Status**: PENDING
**Validation Method**: Query MDP with timestamp comparison against SCADA source; schedule meeting with MDP team lead
**Impact if TRUE**: Application polls MDP every 5-15 seconds; L4 deployment with ICSR Lite approval (2-4 weeks)
**Impact if FALSE**: Application requires L3 deployment with direct MQTT subscription; ICSR Full approval (2-3 months); timeline extends 8+ weeks
**Fallback**: Use SACS database as intermediate source, or demo-only mode with synthetic data
**Severity**: CRITICAL
**Owner**: TBD
**Due Date**: TBD
**Source**: Architecture design discussion
```
