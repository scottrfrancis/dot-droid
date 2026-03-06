---
name: "session-safety"
description: "Prevent session hangs and context loss on hardware development systems with NPU/GPU devices"
---

# Session Safety Guidelines

Prevents session hangs and context loss on hardware development systems, particularly when working with NPU/GPU devices.

## Critical Problem: Session Accumulation

Multiple sessions accessing hardware devices simultaneously causes device contention, driver conflicts, resource leakage, and complete context loss requiring system restart.

## Before Every Session

### 1. Session Cleanup (MANDATORY)

```bash
pkill -f claude || true
pkill -f droid || true
sleep 2
pkill -9 -f claude || true
pkill -9 -f droid || true
ps aux | grep -E "claude|droid" | grep -v grep
```

### 2. Device Resource Validation

```bash
lsof /dev/dri/card0 2>/dev/null && echo "WARNING: Device in use" || echo "Device available"
free -h | grep Mem
timeout 5s docker version >/dev/null || echo "Docker daemon issue"
```

### 3. Environment Reset

```bash
docker container prune -f
docker system prune -f
rm -rf /dev/shm/rknn* 2>/dev/null || true
rm -rf /dev/shm/npu* 2>/dev/null || true
find /tmp -name "*claude*" -mtime +1 -delete 2>/dev/null || true
```

## During Sessions

- Use timeouts on all hardware tests: `timeout 60s docker run --rm --memory=512m ...`
- Save work frequently: `git add . && git commit -m "WIP: checkpoint $(date)" || true`
- Watch for: multiple processes on `/dev/dri/card0`, tests running long, system sluggishness

## Hardware-Specific Rules

- **One session only**: Never run multiple sessions simultaneously
- **Device exclusivity**: Verify exclusive hardware access
- **Resource limits**: Always use memory/CPU limits in containers
- **Timeout everything**: No operation without explicit timeouts
