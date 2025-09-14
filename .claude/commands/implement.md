---
description: "Implement feature from GitHub issue design"
argument-hint: "[issue-number]"
allowed-tools: "Bash(gh:*), Bash(git:*), Bash(just:*), Task(subagent_type:implementation-agent)"
---
Trigger the implementation phase for a designed GitHub issue. This command will:

1. Read the design documentation from the GitHub issue
2. Implement the feature following NixOS best practices
3. Create properly formatted commits
4. Run validation tests and checks
5. Create a pull request with comprehensive description

Provide the GitHub issue number with completed design to implement.

$ARGUMENTS
