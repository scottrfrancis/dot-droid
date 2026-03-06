---
name: "readme-documentation"
description: "README as central documentation hub with linked navigation patterns"
---

# README Documentation Guidelines

## Core Principle

All user-facing information must be accessible from the README.md file, either directly included or linked. The README serves as the single entry point.

## README Structure

Every README.md should include these sections in order:

1. **Project Title and Description** — What the project does
2. **Installation/Setup** — How to get started
3. **Usage** — Basic usage examples
4. **Documentation** — Links to all other documentation
5. **Contributing** — How to contribute (if applicable)
6. **License** — Legal information

## Documentation Patterns

### Small Projects — Inline README

Include all documentation directly in README.md.

### Medium Projects — Linked Documentation

Use a `docs/` directory with clear navigation from the README.

### Large Projects — Multi-Section Documentation

Organize by audience: For Users, For Developers, For Contributors.

## Best Practices

- Use descriptive link text: `[User Guide](docs/user-guide.md)` not `[here](docs/guide.md)`
- Include brief descriptions explaining what each linked document contains
- Use relative paths for links
- Verify all links work
- Keep links current when adding new documentation
