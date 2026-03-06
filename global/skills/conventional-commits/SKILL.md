---
name: "conventional-commits"
description: "Standardized commit message format following Conventional Commits specification"
---

# Conventional Commits Guidelines

All projects must use [Conventional Commits](https://www.conventionalcommits.org/) format for git commit messages.

## Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **build**: Changes that affect the build system or external dependencies
- **ci**: Changes to CI configuration files and scripts
- **chore**: Other changes that don't modify src or test files
- **revert**: Reverts a previous commit

## Examples

```
feat: add user authentication
fix: prevent race condition in data processing
feat(auth): add OAuth2 support
fix(parser): handle empty input gracefully
```

### With breaking change

```
feat(api): change authentication method

BREAKING CHANGE: API now uses JWT tokens instead of API keys
```

## Best Practices

1. Use present tense: "add feature" not "added feature"
2. Use imperative mood: "move cursor to..." not "moves cursor to..."
3. Don't capitalize first letter after the colon
4. No period at the end of the subject line
5. Keep subject line under 72 characters
6. Reference issues when applicable (e.g., "Fixes #123")
7. Use scope to indicate which part of the codebase changed
