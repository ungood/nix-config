---
description: "Create a formatted git commit with current changes"
argument-hint: "[commit-message]"
allowed-tools: "Bash(git:*)"
---
Create a well-formatted git commit summarizing the current changes. If no message is provided, will analyze changes and create an appropriate commit message.

If the main branch is not currently checked, warn the user and ask for guidance.

$ARGUMENTS
