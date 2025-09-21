---
description: "Smart implementation workflow based on issue complexity"
argument-hint: "[issue-number]"
allowed-tools: "Bash(gh:*), Bash(git:*), Bash(just:*), Task(subagent_type:software-engineer), Task(subagent_type:product-owner), Task(subagent_type:architect)"
---

Intelligently implement a GitHub issue by first assessing its complexity and choosing the appropriate workflow:

## Complexity Assessment
The command first reads the GitHub issue and determines:
- **Trivial**: Typos, documentation fixes, comments - no behavior changes
- **Simple**: 1-line fixes, config tweaks, minor adjustments
- **Medium**: Small features, bug fixes, refactoring within single modules
- **Complex**: Multi-module features, architectural changes, new systems

## Workflow Selection

### Trivial Issues (Direct Commit)
- Read issue and implement directly on main branch
- Make changes, basic validation, commit directly
- No PR or additional testing needed

### Simple Issues (Direct Implementation)
- Read issue and implement directly
- Create branch, make changes, test, create PR
- No additional agents needed

### Medium Issues (Design + Implementation)
- Use architect agent for technical design
- Use software-engineer agent for implementation
- Create design doc, then implement

### Complex Issues (Full Workflow)
- Use product-owner agent for requirements analysis
- Use architect agent for comprehensive technical design
- Use software-engineer agent for implementation
- Full documentation and design phase

## Usage
Provide the GitHub issue number to analyze and implement:

$ARGUMENTS
