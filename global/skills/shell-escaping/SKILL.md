---
name: "shell-escaping"
description: "Shell quoting, TTY handling, and terminal compatibility across VS Code, native terminals, and CI/CD"
---

# Shell Escaping and Terminal Compatibility

## Key Principles

### 1. Never Use Line Continuations Inside Quoted Strings

```bash
# WRONG - backslash becomes literal inside quotes
local docker_cmd="docker run --rm \
    -v $(pwd):/workspace \
    my-image"

# CORRECT - build incrementally
local docker_cmd="docker run --rm"
docker_cmd="$docker_cmd -v $(pwd):/workspace"
docker_cmd="$docker_cmd my-image"

# BEST - use arrays for complex commands
local docker_args=(
    "docker" "run" "--rm"
    "-v" "$(pwd):/workspace"
    "my-image"
)
"${docker_args[@]}"
```

### 2. Handle TTY Detection

```bash
local docker_flags="--rm"
if [ -t 0 ] && [ "$QUIET" != true ] && [ "$CI" != true ]; then
    docker_flags="-it --rm"
fi
```

### 3. Minimize eval Usage

Prefer direct execution or arrays over eval with dynamic strings.

### 4. Quote Variables Consistently

```bash
docker run -v "$PWD:/workspace" image  # Correct
```

## Testing Checklist

- [ ] Native terminal (bash, zsh)
- [ ] VS Code integrated terminal
- [ ] SSH session (often no TTY)
- [ ] CI/CD environment
- [ ] With special characters in paths (spaces, quotes)

## Debugging

```bash
[ -t 0 ] && echo "TTY available" || echo "No TTY"
echo "TERM: ${TERM:-not set}"
set -x  # Enable debug mode
printf '%q\n' "$your_variable"  # Show how bash sees it
```
