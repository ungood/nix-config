# Automated Development Workflow

This document describes the automated development workflow using Claude Code subagents, GitHub integration, and hooks for streamlined feature development.

## Overview

The workflow consists of 4 automated phases:

1. **Ideation** - Brainstorm and create GitHub issues
2. **Research & Design** - Analyze requirements and create technical designs
3. **Implementation** - Develop features following NixOS best practices
4. **Review & Testing** - Automated code review and validation

## Commands

### `/ideate [feature-description]`
Start the development workflow by brainstorming a new feature.

**Example:**
```bash
/ideate Add support for Hyprland desktop environment
```

**What it does:**
- Interactive brainstorming session to refine the idea
- Generates comprehensive GitHub issue with requirements
- Creates feature branch
- Automatically triggers research phase

### `/research [issue-number]`
Manually trigger research and design phase for a GitHub issue.

**Example:**
```bash
/research 42
```

**What it does:**
- Analyzes issue requirements and codebase
- Creates technical design document
- Generates implementation task breakdown
- Updates GitHub issue with design documentation

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

### Complete Automated Workflow
```
/ideate "Add feature X"
    ↓ (creates GitHub issue)
    ↓ (hook triggers automatically)
Research Agent analyzes and designs
    ↓ (updates issue with design)
    ↓ (manual or automated trigger)
Implementation Agent builds feature
    ↓ (creates pull request)
    ↓ (hook triggers automatically)
Review Agent tests and reviews
    ↓ (auto-merge or request human review)
✅ Feature complete
```

### Manual Override Points
You can manually intervene at any phase:
- Use `/research [issue]` to re-run design phase
- Use `/implement [issue]` to re-run implementation
- Use `/review-pr [pr]` to re-run review process

## Subagents

### Research Agent
- **Purpose**: Analyze GitHub issues and create technical designs
- **Capabilities**: Codebase analysis, architecture design, task breakdown
- **Output**: Technical design document and implementation plan

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
