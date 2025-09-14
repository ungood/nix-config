# Automated Development Workflow

This document describes the automated development workflow using Claude Code subagents, GitHub integration, and hooks for streamlined feature development.

## Overview

The workflow consists of 5 phases:

1. **Issue Creation** - Quick capture of features/bugs with minimal detail
2. **Requirements Definition** - Analyze and define detailed requirements and scope
3. **Technical Design** - Create implementation architecture and approach
4. **Implementation** - Develop features following NixOS best practices
5. **Review & Testing** - Automated code review and validation

## Commands

### `/suggest-feature [description]`
Quickly suggest a new feature with minimal overhead.

**Example:**
```bash
/suggest-feature Add support for Wayland screen sharing
```

**What it does:**
- Creates GitHub issue with brief feature description
- Auto-assigns `enhancement` label
- Minimal time investment (30 seconds)

### `/report-bug [description]`
Quickly report a bug with essential triage information.

**Example:**
```bash
/report-bug KDE system tray icons disappear after sleep
```

**What it does:**
- Creates GitHub issue with bug details
- Prompts for expected vs actual behavior
- Auto-assigns `bug` and `needs-triage` labels
- Gathers basic environment information

### `/define [issue-number]`
Define detailed requirements and scope for a GitHub issue.

**Example:**
```bash
/define 42
```

**What it does:**
- Analyzes issue and gathers additional requirements
- Researches codebase for context and dependencies
- Defines clear scope boundaries and constraints
- Creates detailed acceptance criteria
- Focuses on WHAT needs to be built

### `/design [issue-number]`
Create technical design for a well-defined GitHub issue.

**Example:**
```bash
/design 42
```

**What it does:**
- Reads detailed requirements from GitHub issue
- Researches existing codebase patterns
- Designs technical solution and implementation approach
- Creates detailed implementation tasks
- Focuses on HOW to build the solution

### `/implement [issue-number]`
Manually trigger implementation phase for a designed issue.

**Example:**
```bash
/implement 42
```

**What it does:**
- Reads design from GitHub issue
- Implements feature following repository conventions
- Runs validation tests (`just check`, `just build`)
- Creates pull request with comprehensive description

### `/review-pr [pr-number]`
Manually trigger review and testing for a pull request.

**Example:**
```bash
/review-pr 15
```

**What it does:**
- Performs comprehensive code review
- Runs full test suite and validation
- Checks security and best practices
- Posts review comments and auto-merges if appropriate

## Automation Flow

### Complete Workflow
```
/suggest-feature "Add feature X"
    ↓ (creates GitHub issue)
    ↓ (manual progression)
/define [issue-number]
    ↓ (updates issue with detailed requirements)
    ↓ (manual progression)
/design [issue-number]
    ↓ (updates issue with technical design)
    ↓ (manual progression)
/implement [issue-number]
    ↓ (creates pull request)
    ↓ (hook triggers automatically)
Review Agent tests and reviews
    ↓ (auto-merge or request human review)
✅ Feature complete
```

### Quick Bug Reporting Flow
```
/report-bug "Bug description"
    ↓ (creates GitHub issue with triage info)
    ↓ (manual triage and prioritization)
/define [issue-number] (if needed)
    ↓ (clarify requirements)
/design [issue-number] (if needed)
    ↓ (plan technical fix)
/implement [issue-number]
    ↓ (fix implementation and testing)
✅ Bug resolved
```

### Manual Control Points
Each phase is manually triggered, giving you control over:
- When to move from initial idea to detailed requirements
- When requirements are sufficient for technical design
- When design is ready for implementation
- Ability to iterate on any phase before proceeding

## Subagents

### Product Owner Agent
- **Purpose**: Analyze GitHub issues and define detailed requirements, scope, and acceptance criteria
- **Capabilities**: Requirements analysis, scope definition, user story creation, acceptance criteria development
- **Output**: Comprehensive requirements document with clear scope and success criteria

### Architect Agent
- **Purpose**: Create technical designs and implementation plans based on well-defined requirements
- **Capabilities**: Technical architecture design, system integration analysis, implementation strategy development
- **Output**: Technical design document with implementation approach and detailed tasks

### Implementation Agent
- **Purpose**: Implement features based on GitHub issue designs
- **Capabilities**: NixOS module development, testing, Git workflow
- **Output**: Working implementation with tests and documentation

### Review Agent
- **Purpose**: Comprehensive code review and validation
- **Capabilities**: Quality analysis, security review, automated testing
- **Output**: Review feedback and merge decisions

## Best Practices

### Issue Creation
- Provide clear feature descriptions in `/ideate`
- Include specific requirements and constraints
- Mention any dependencies or integration points

### Design Review
- Review the generated technical design before implementation
- Add comments to GitHub issue for additional requirements
- Use `/research [issue]` to regenerate design if needed

### Implementation Validation
- All implementations are tested with `just check` and `just build`
- Follow existing NixOS module conventions
- Include appropriate documentation updates

### Code Review
- Review agent checks for security, quality, and best practices
- Auto-merge only occurs for low-risk changes
- Human review requested for breaking changes or complex features

## Configuration Files

```
.claude/
├── commands/
│   ├── ideate.md       # Brainstorming command
│   ├── research.md     # Research trigger
│   ├── implement.md    # Implementation trigger
│   └── review-pr.md    # Review trigger
├── agents/
│   ├── research-agent.md       # Research subagent config
│   ├── implementation-agent.md # Implementation subagent config
│   └── review-agent.md         # Review subagent config
├── hooks/
│   ├── issue-created.sh     # Auto-trigger research
│   ├── design-completed.sh  # Auto-trigger implementation
│   └── pr-created.sh        # Auto-trigger review
└── settings.json            # Permissions and hook configuration
```

## Troubleshooting

### Common Issues

**Hooks not triggering:**
- Check `.claude/settings.json` permissions
- Verify hook scripts are executable (`chmod +x .claude/hooks/*.sh`)
- Check GitHub CLI authentication (`gh auth status`)

**Subagent permissions:**
- Ensure `Task(subagent_type:*)` permissions are allowed
- Check individual tool permissions for agents

**Build failures:**
- Run `just check` manually to validate configuration
- Check NixOS module syntax and imports
- Verify flake structure is maintained

### Manual Workflow Recovery
If automation fails, you can manually run each phase:
1. Create GitHub issue manually
2. Use `/research [issue-number]`
3. Use `/implement [issue-number]`
4. Use `/review-pr [pr-number]`

## Security Considerations

- All implementations are reviewed for security best practices
- No secrets or credentials are committed to repository
- Appropriate file permissions are validated
- Breaking changes require human review before merge

## Performance Tips

- Use descriptive feature names for better GitHub issue organization
- Review generated designs before implementation to catch issues early
- Leverage existing NixOS modules and patterns for faster development
- Monitor resource usage with complex configurations
