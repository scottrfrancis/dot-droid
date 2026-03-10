---
name: "security-hardening"
description: "Defense-in-depth patterns grounded in real-world breach analysis"
---

# Web Application Security Hardening

Patterns extracted from real-world breach analysis and incident response. Apply these when building or auditing any web application that handles sensitive data.

---

## Breach-Driven Audit Methodology

When a real security incident affects your domain (same industry, same client, same data category), don't just read the news. Audit your codebase against the same attack pattern.

**Process:**

1. **Map the attack vector** — What did the attacker actually do?
2. **Translate to your system** — What's the equivalent path in your codebase?
3. **Audit each link in the chain** — Could the same attack succeed against your system right now?
4. **Prioritize by breach relevance** — Findings directly analogous to the real breach are P0. Findings that increase impact are P1. Operational hygiene is P2.
5. **Fix and test** — Every finding gets a fix and a test. Ship as a single hardening PR.

This is more effective than generic OWASP checklists because it's focused on proven, exploitable patterns — not theoretical risks.

---

## Authentication Hardening Checklist

### Password Storage

- **Always hash passwords** — Use bcrypt, argon2, or scrypt. Never compare plaintext.
- **Check for imported-but-unused hashing** — Verify the hash function is actually called on the login path.
- **Validate secrets at startup** — If a JWT secret or session secret has a default value in code, reject startup if the default hasn't been changed. Check minimum length (32+ chars).

### Authentication Flow

- **No silent auth fallbacks** — If your primary auth (e.g., OAuth/OIDC) fails, do not silently fall back to a weaker mechanism. A fallback that bypasses MFA is worse than no fallback.
- **Default-deny roles** — Never default to `admin` when role is missing from a token or user record. Default to the most restrictive role.
- **Rate limit login endpoints** — 5 attempts per IP per minute is a reasonable starting point. Apply to login, password reset, and token exchange endpoints.
- **Log all auth events** — Every successful and failed login: username, IP, timestamp, result. Use structured logging with consistent event names (`AUTH_SUCCESS`, `AUTH_FAILED`).

### Multi-Factor Authentication

- **MFA at the identity provider level** — TOTP at minimum.
- **Don't let application-level fallbacks bypass IdP MFA** — If Cognito/Auth0/Okta enforces MFA, your app must not provide an alternative auth path that skips it.

---

## Authorization Patterns

### Tenant Isolation

- **Customer-scoped access control** — Users should only access their assigned tenants/customers. Never rely solely on "the user is authenticated" as sufficient authorization.
- **Validate tenant access on every request** — The backend must check `user.assignments` against the requested `customer_id` on every API call.
- **Log access decisions** — Log both `ACCESS_GRANTED` and `ACCESS_DENIED` with user, resource, and timestamp.

### Role-Based Access

- **Minimum viable role model** — admin, operator/user, viewer. Use a decorator or middleware (`require_role("admin")`) rather than inline checks.
- **Never default-grant admin** — If a user's role is unknown or missing, treat them as unauthenticated.

---

## Input Validation

### Path Traversal Prevention

- **Validate all user-controlled path components** — Reject strings containing `..` or `/`.
- **Verify resolved paths** — After constructing a file path, use `Path.resolve()` and check `is_relative_to(expected_directory)`.
- **Apply to file downloads, uploads, and directory listings** — Any endpoint that touches the filesystem.

### Upload Validation

- **File size limits** — Enforce at the application level. 50MB is a reasonable default for document uploads.
- **MIME type verification** — Check the file's actual content type, not just the extension.
- **Archive protection** — For zip/tar uploads, check decompressed size before extracting (zip bomb protection). Set a ratio limit (e.g., 100:1 maximum).

---

## Internal Endpoint Protection

**Never assume network isolation is sufficient auth.** Internal endpoints (schedulers, health checks, admin APIs) need authentication even if they're "only accessible within Docker/VPC."

Why:
- SSRF vulnerabilities can reach internal endpoints from the public internet
- Misconfigured reverse proxies can expose internal ports
- Post-breach lateral movement targets unauthenticated internal services

**Pattern:** Use a shared secret token (`X-Scheduler-Token` header) stored in an environment variable, not in code.

---

## Operational Security

### Secrets Management

- **Secrets in environment variables** — Never in code, config files committed to git, or Docker images.
- **No default secrets in code** — Add startup validation that rejects default values.
- **Secret redaction in logs** — Add a logging filter that masks API keys, JWTs, passwords, and connection strings.

### Port Exposure

- **Only expose the reverse proxy** — Backend services bind to `127.0.0.1`. Only nginx/caddy/traefik listens on `0.0.0.0:443`.
- **Review `docker-compose.yml` port mappings** — Every `ports:` directive that isn't the reverse proxy is a potential bypass of your security controls.

### Credential Hygiene

- **Don't reuse credentials across environments** — dev, staging, production each get unique credentials.

---

## Defense in Depth Summary

```
Layer 1: Authentication (OAuth/OIDC + MFA)
  ↓ attacker needs valid token
Layer 2: Authorization (RBAC + tenant isolation)
  ↓ attacker needs correct role AND customer assignment
Layer 3: Data access control (read-only DB, scoped queries)
  ↓ attacker can only read, not modify
Layer 4: Monitoring (auth logging, access audit, rate limiting)
  ↓ attack is detected and investigated
Layer 5: Operational (secrets rotation, port isolation, log redaction)
  ↓ blast radius is minimized
```

---

## Security Test Categories

**Tier 1 — Direct breach vectors:**
- Password hashing (verify bcrypt, not plaintext)
- Rate limiting on auth endpoints
- Auth event logging (success + failure)
- Auth fallback behavior (no silent downgrade)

**Tier 2 — Production hardening:**
- Internal endpoint auth (scheduler, health check)
- Path traversal prevention (file downloads, customer IDs)
- Upload validation (size, MIME, archive safety)
- Access decision logging (granted + denied)
- Secret validation at startup
- Secret redaction in logs
- Role enforcement (default-deny)
- Port binding (localhost only for backend)
