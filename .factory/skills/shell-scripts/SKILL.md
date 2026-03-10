---
name: "shell-scripts"
description: "Shell script best practices: directory management, error handling, cleanup traps, and portability"
---

# Shell Script Best Practices

Guidelines for writing maintainable, portable, and reliable shell scripts.

## Directory Management

### Always Detect Script Directory

```bash
#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
```

### Use pushd/popd for Directory Navigation

```bash
pushd "${SCRIPT_DIR}/data" > /dev/null || {
    echo "Error: Cannot access data directory" >&2
    exit 1
}
process_files
popd > /dev/null
```

### Always Use Absolute Paths from SCRIPT_DIR

```bash
CONFIG_FILE="${SCRIPT_DIR}/config/settings.conf"
DATA_DIR="${SCRIPT_DIR}/data"
source "${CONFIG_FILE}"
```

## Error Handling

### Clean Up on Exit

```bash
cleanup() {
    popd > /dev/null 2>&1 || true
}
trap cleanup EXIT
```

## Complete Template

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CONFIG_DIR="${SCRIPT_DIR}/config"
DATA_DIR="${SCRIPT_DIR}/data"

cleanup() {
    popd > /dev/null 2>&1 || true
}
trap cleanup EXIT

main() {
    pushd "${DATA_DIR}" > /dev/null || {
        echo "Error: Cannot access data directory" >&2
        exit 1
    }
    for file in *.csv; do
        [ -f "$file" ] || continue
        echo "Processing: $file"
    done
    popd > /dev/null
}

main "$@"
```

## Best Practices

1. Use shellcheck to validate scripts
2. Always quote variable expansions: `"${VAR}"`
3. Use `set -euo pipefail` at the start
4. Provide usage info for script arguments
5. Use `#!/usr/bin/env bash` for portability
