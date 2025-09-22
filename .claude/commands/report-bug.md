---
description: "Quickly report a bug with essential triage information"
argument-hint: "[bug-description]"
allowed-tools: "Bash(gh:*), Bash(git:*)"
---
Quickly create a GitHub issue for a bug report with essential information for triage.

This command will:
1. Capture the bug description
2. Prompt for expected vs actual behavior
3. Gather basic reproduction steps
4. Auto-detect environment information where possible
5. Create a GitHub issue with the `bug`

Provide a brief description of what's broken or not working as expected.

Example: `/report-bug KDE system tray icons disappear after sleep`

$ARGUMENTS
