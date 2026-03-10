---
name: "ai-patterns"
description: "LLM integration patterns: caching, routing, guardrails, RAG, multi-agent orchestration"
---

# AI Systems Engineering Patterns

Reference guide based on [AI Systems Engineering Patterns](https://blog.alexewerlof.com/p/ai-systems-engineering-patterns) by Alex Ewerlof.

## Interface Patterns

1. **Structured JSON Prompting** — Validate input against schema before reaching the LLM
2. **Prompt Template Pattern** — Treat prompts as source code, user input as variables
3. **Structured Outputs** — Force AI output to valid JSON via native constraints

## Prompting & Context Patterns

4. **Context Caching** — Cache static prompt portions to reduce cost (up to 80%)
5. **Progressive Summarization** — Compress oldest messages to maintain fixed context size
6. **Memory Management** — Distinguish episodic (events) from semantic (facts) memory

## Routing & Optimization

7. **Router Pattern** — Classify intent, route to appropriate model/tool
8. **Skills / Lazy Loading** — Load tool definitions on-demand (critical with 10+ tools)
9. **Model Selection** — Dense models for complex reasoning, sparse/MoE for high-volume

## Caching & Performance

10. **Semantic Caching** — Return cached response for semantically similar queries. Requires tenant isolation.
11. **LLM Gateway** — Centralized proxy for auth, rate limiting, failover across providers

## Security & Safety

12. **Sanitization Middleware** — Input/output filtering. Never expose a raw LLM directly.
13. **Prompt Injection Defense** — Validate, sandbox, detect malicious instructions
14. **PII Protection** — Detect and redact PII, scope caches to users

## Architecture Patterns

15. **RAG** — Augment LLM with external knowledge retrieval
16. **Multi-Agent Orchestration** — Sequential, parallel, hierarchical, or debate patterns
17. **Flow Engineering** — Design multi-step workflows for complex tasks

## Implementation Checklist

- [ ] Input handling: structured inputs or sanitized templates?
- [ ] Output validation: structured outputs or post-processing?
- [ ] Caching strategy: semantic caching with tenant isolation?
- [ ] Routing: appropriate model selection per query type?
- [ ] Security: guardrails for input/output? Prompt injection defense?
- [ ] Resilience: LLM gateway or fallback strategy?
- [ ] Cost optimization: context caching? Router pattern?
- [ ] Observability: logging, metrics, evaluation loops?
