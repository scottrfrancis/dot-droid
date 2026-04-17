---
name: "review-pr"
description: "PR code review for bugs, security issues, missing tests, and style"
model: "claude-sonnet-4-6"
tools: ["read", "execute", "search"]
---

# PR Code Review

Review a pull request for bugs, security issues, missing tests, and code quality.

## Step 0 — Invoke `/ultrareview` (REQUIRED)

Before doing anything else, you MUST explicitly invoke the `/ultrareview` slash command (available on Claude 4.7+ models) to run Claude's specialized bug-hunting reviewer fleet against the changed files. This is non-optional — `/ultrareview` is the primary source of findings for this review; the manual checklist in later steps is a supplement, not a replacement.

- Run `/ultrareview` and wait for it to complete.
- Capture the findings it produces.
- Treat any HIGH/critical items it surfaces as required review items.

If `/ultrareview` is unavailable in the current environment (e.g., the host model/client doesn't expose the slash command), say so explicitly in the final review output and continue with the manual checklist below.

## Step 1 — Resolve the diff

Determine what to review:

- **PR number** (e.g., `123`): Run `gh pr diff 123` and `gh pr view 123 --json title,body,baseRefName,headRefName`
- **Branch name** (e.g., `feature/foo`): Run `git diff main...feature/foo`
- **No arguments**: Run `git diff main...HEAD` for current branch vs main

Also run `git log --oneline main...HEAD` for commit history context.

If the diff is empty, report "No changes to review" and stop.

## Step 2 — Read changed files for full context

For each file with non-trivial changes, read the full file to understand surrounding context. Skip trivial changes (whitespace, comment-only, lockfile updates).

## Step 3 — Review checklist

Evaluate the diff against each category. Only report findings — skip clean categories.

### Bugs & Logic Errors
- Off-by-one errors, incorrect comparisons, swapped arguments
- Unhandled null/undefined, missing error propagation
- Race conditions, state mutations in unexpected order

### Security (OWASP Top 10)
- Injection: SQL, command, path traversal, template injection
- Auth: missing or weakened auth checks, hardcoded secrets
- Data exposure: sensitive data in logs, error messages, or API responses
- XSS: unsanitized user input in HTML/JSX output

### Missing Tests
- New public functions or API endpoints without test coverage
- Changed behavior that existing tests don't cover
- Edge cases visible in the diff

### API & Contract Changes
- Breaking changes to public APIs, function signatures, or database schemas
- Changed return types or response shapes without migration

### Style & Conventions
- Only flag issues that affect correctness or maintainability
- Do NOT flag formatting preferences — defer to linters

## Step 4 — Output the review

**Merge findings from `/ultrareview` (Step 0) with findings from the manual checklist (Step 3)**, deduplicating and prefixing each finding's source as `[ultrareview]` or `[manual]` in the Finding column where helpful. Group findings by file:

```
## PR Review: <title or branch>

### Summary
<1-2 sentence overall assessment>

### Findings

#### `path/to/file.ts`

| # | Severity | Line | Finding | Suggestion |
|---|----------|------|---------|------------|
| 1 | HIGH | 42 | Description | Fix |

### Verdict

**Approve** / **Request Changes** / **Comment**
```

Severity: HIGH (must fix), MEDIUM (should fix), LOW (nice to fix).
