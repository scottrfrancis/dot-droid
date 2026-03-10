---
name: "readme-documentation"
description: "README as central documentation hub with linked navigation patterns"
---

# README Documentation Guidelines

## Core Principles

**Single entry point.** All user-facing information must be accessible from README.md, either directly included or linked. Users should never need to hunt through the repository structure to find documentation.

**DRY — Don't Repeat Yourself.** Each fact lives in exactly one place. When the same information is needed in multiple sections or files, link to the canonical source — never copy it. Duplicated docs drift apart and contradict each other.

**Describe current state. Git keeps history.** Write documentation that reflects how the project works *right now*. Do not narrate evolution ("previously we used X, now we use Y") or add "added in v2.0"-style annotations.

## README Structure

Every README.md should include these sections in this order:

1. **Project Title and Description** — What the project does
2. **Installation/Setup** — How to get started
3. **Usage** — Basic usage examples
4. **Documentation** — Links to all other documentation
5. **Contributing** — How to contribute (if applicable)
6. **License** — Legal information

### Documentation Section

**Do this:**
```markdown
## Documentation

- [User Guide](docs/user-guide.md) - Complete usage instructions
- [API Reference](docs/api/README.md) - Full API documentation
- [Developer Guide](docs/development.md) - Setup for contributors
- [Architecture](docs/architecture.md) - System design and structure
- [Changelog](CHANGELOG.md) - Version history
```

**Don't do this:**
```markdown
## Documentation

See the docs folder for more information.
```

## Documentation Organization Patterns

### Pattern 1: Inline README (Small Projects)

Include all documentation directly in README.md.

### Pattern 2: Linked Documentation (Medium Projects)

Use a `docs/` directory with clear navigation:

```markdown
## Documentation

- **[User Guide](docs/user-guide.md)** - Complete usage instructions
- **[API Reference](docs/api.md)** - Method and endpoint documentation
- **[Examples](docs/examples/)** - Code examples and tutorials
- **[FAQ](docs/faq.md)** - Common questions and solutions

## Development

- **[Contributing](docs/contributing.md)** - How to contribute
- **[Development Setup](docs/development.md)** - Environment setup
- **[Architecture](docs/architecture.md)** - Technical overview
```

### Pattern 3: Multi-Section Documentation (Large Projects)

Organize by audience:

```markdown
## For Users
- **[Installation Guide](docs/installation.md)** - Setup instructions
- **[User Manual](docs/user-manual.md)** - Complete usage guide

## For Developers
- **[API Documentation](docs/api/)** - Complete API reference
- **[Architecture Guide](docs/architecture.md)** - Technical overview

## For Contributors
- **[Contributing Guide](docs/contributing.md)** - How to contribute
- **[Development Setup](docs/development.md)** - Environment setup
```

## Directory Structure

```
docs/
├── README.md              # Documentation index (optional)
├── user-guide.md
├── api/
│   ├── README.md          # API overview
│   ├── authentication.md
│   └── endpoints.md
├── examples/
│   └── basic-usage.md
└── development/
    └── setup.md
```

## Linking Best Practices

1. **Use descriptive link text**: `[User Guide](docs/user-guide.md)` not `[here](docs/user-guide.md)`
2. **Include brief descriptions**: Explain what each linked document contains
3. **Use relative paths**: `docs/guide.md` not `/project/docs/guide.md`
4. **Verify all links work**: Broken documentation links frustrate users

## DRY in Practice

Each piece of information has one canonical home. Everything else links to it.

**Do this:**
```markdown
## Installation

See the [Installation Guide](docs/installation.md) for full details.

Quick start: `npm install my-tool`
```

**Don't do this:**
```markdown
## Installation

Run `npm install my-tool`. Configure it by setting `API_KEY` in your environment...

## Configuration

Set `API_KEY` in your environment...
```

If a config option is documented in `docs/configuration.md`, the README mentions it once with a link — it does not also describe it inline.

## Navigation Aids

For longer READMEs, add a table of contents:

```markdown
## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Documentation](#documentation)
- [Contributing](#contributing)
```

## Maintenance Checklist

1. **Keep links current**: Verify all documentation links work when adding or moving files
2. **Update navigation**: When adding new docs, update README links
3. **Review organization**: Periodically assess if the structure still makes sense
4. **Prune historical narrative**: Remove "previously", "as of v2", "we changed this because". If the information is still relevant, restate it as current fact; otherwise delete it.
