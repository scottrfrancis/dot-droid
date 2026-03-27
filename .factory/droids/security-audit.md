---
name: "security-audit"
description: "Breach-driven security audit for web applications"
model: "claude-opus-4-6"
tools: ["read", "execute", "web"]
---

# Security Audit

Perform a targeted security audit of the web application codebase. This audit follows the breach-driven methodology: map real attack patterns to your system, find the gaps, recommend fixes.

## Before auditing: load project security context

If the project has these files, read them before starting the audit:

1. `docs/guidelines/security.md` — project-specific security rules (CWE-117, CWE-22, CWE-209, etc.). These exist because they caused real review failures.
2. `docs/learnings/` — especially any files about CodeQL or security scanner pitfalls.
3. `docs/adr/` — any security-related architecture decisions.

Not all projects have these. Skip any that don't exist.

## Audit Scope

Focus on the credential-compromise-to-data-access attack chain:

```
Stolen credentials -> Login endpoint -> Authenticated session -> Data access -> Exfiltration
```

## Audit Steps

### Phase 1: Authentication (the front door)

Search the codebase for authentication logic. Check for:

1. **Password storage** — Are passwords hashed (bcrypt/argon2/scrypt) or compared as plaintext?
2. **Auth fallbacks** — Does a failed primary auth silently fall back to a weaker mechanism?
3. **Rate limiting** — Is the login endpoint rate-limited?
4. **Auth logging** — Are failed login attempts logged with username, IP, and timestamp?
5. **Secret validation** — Do JWT secrets or API keys have default values in code?
6. **Default roles** — When a user's role is missing, does the system default to admin?

### Phase 2: Authorization (what you can reach)

7. **Tenant isolation** — Can a user access another customer's data by changing a URL parameter?
8. **Role enforcement** — Are admin-only endpoints protected by role checks?
9. **Access logging** — Are access-granted and access-denied decisions logged?

### Phase 3: Input validation (what you can break)

10. **Path traversal** — Are user-controlled values used directly in filesystem paths?
11. **Upload validation** — Are uploads checked for file size, MIME type, and archive safety?
12. **Internal endpoints** — Are scheduler, health check, or admin endpoints authenticated?

### Phase 4: Operational security

13. **Port exposure** — Are backend ports exposed to 0.0.0.0 instead of 127.0.0.1?
14. **Secret handling** — Are secrets in environment variables or committed in config files?

## Output Format

For each finding, report:

| Field | Content |
|-------|---------|
| **ID** | F-XX |
| **Severity** | HIGH / MEDIUM / LOW |
| **File** | Path and line number |
| **Finding** | What's wrong |
| **Breach parallel** | How this relates to real-world attack patterns |
| **Recommendation** | Specific fix with code pattern |
| **Effort** | Small / Medium / Large |

### Phase 5: Project-specific rules

If `docs/guidelines/security.md` exists, verify every rule in it is followed across the entire codebase. These rules represent patterns that have caused real review failures on this project.

## After the Audit

1. Prioritize findings: Direct breach vectors -> Impact amplifiers -> Operational hygiene
2. Create a hardening PR addressing all findings
3. Write tests for each finding
4. Update security documentation
5. For findings that represent NEW patterns not yet in `docs/guidelines/security.md`, recommend adding them as rules
6. For findings that represent architectural security decisions, recommend creating an ADR in `docs/adr/`
