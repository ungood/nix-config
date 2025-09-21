---
description: "Implement feature from GitHub issue design"
argument-hint: "[issue-number]"
allowed-tools: "Bash(gh:*), Bash(git:*), Bash(just:*), Task(subagent_type:software-engineer)"
---

Trigger the implementation phase for a designed GitHub issue. This command will:

1. Read the GitHub issue
2. Create a feature branch main to contain all work
3. Implement the feature following the project's conventions and best practices
4. Create properly formatted commits
5. Run linting and tests
6. Create a pull request

Provide the GitHub issue number with completed design to implement.

$ARGUMENTS
