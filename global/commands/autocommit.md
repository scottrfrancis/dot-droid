---
name: "autocommit"
description: "AI-powered conventional commit message generation"
---

# Auto Commit

Generate and apply a conventional commit message based on staged or unstaged changes.

## Steps

1. Run `git status --porcelain` to see what changed
2. If no changes, report "Nothing to commit" and exit
3. Analyze the changes and generate a commit message following Conventional Commits:
   - Format: `<type>[optional scope]: <description>`
   - Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
   - Keep subject line under 72 characters
   - Use present tense and imperative mood
4. Show the proposed commit message to the user
5. Ask for confirmation before committing
6. If confirmed: `git add . && git commit -m "<message>"`
