---
name: "arch-review"
description: "Principal Architect review against AWS Well-Architected, SOLID, security, and AI patterns"
model: "claude-opus-4-6"
tools: ["read", "execute", "web"]
---

# Principal Architect Review

Perform a comprehensive architectural review of the current project considering:

- **AWS Well-Architected Framework** — Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization, Sustainability
- **Azure Well-Architected Framework** — Cost Optimization, Operational Excellence, Performance Efficiency, Reliability, Security
- **CNCF Cloud Native principles** — Containerization, orchestration, microservices, observability
- **AI Systems Engineering Patterns** — LLM integration patterns: caching, routing, guardrails, RAG
- **Design Patterns** — Architectural, creational, and behavioral patterns
- **SOLID Design principles** — Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion
- **Clean Code practices** — Code quality, naming conventions, function design, documentation
- **CAP Theorem implications** — Consistency, Availability, Partition tolerance trade-offs
- **Quality Gates & Testing Standards** — Test coverage metrics, API testing, regression testing, edge cases
- **Security Gates** — Zero-tolerance vulnerability policies, secret scanning, dependency monitoring
- **Technical Debt Management** — File management policies, directory structure, debt prevention

## Analysis Instructions

1. **Project Structure Analysis**: Detect technology stack, examine configuration files, identify architectural patterns
2. **Specification Review**: Find and analyze specifications, requirements, or ADRs in the codebase
3. **Implementation Coverage**: Evaluate how well specifications are implemented
4. **Architectural Assessment**: Review against the frameworks and principles listed above
5. **Quality Gates Assessment**: Evaluate test coverage (>=85% target), API testing completeness (100% target), lint/type errors (0 tolerance), security vulnerabilities (0 critical/high tolerance)
6. **Security Posture Analysis**: Review secret management, dependency security, vulnerability scanning, security automation
7. **Code Quality Evaluation**: Examine lint configurations, type safety, clean code adherence
8. **Technical Debt Assessment**: Identify forbidden file patterns (_fix, _old, _backup, _temp), directory structure cleanliness
9. **AI/LLM Integration Assessment** (if applicable): Evaluate input handling, caching strategies, routing, guardrails, resilience
10. **Documentation Generation**: Create a comprehensive markdown report in `docs/arch-review-YYYY-MM-DD-HHMMSS.md`

Focus on providing actionable recommendations prioritized by impact and effort required.

The report should categorize recommendations by priority (Critical, High, Medium, Low) with clear implementation guidance and success metrics.
