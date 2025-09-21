# Contributing

This document describes how to build, test, and contribute to this NixOS configuration repository.

## Prerequisites

- NixOS with flakes enabled
- Git
- just

## Development Workflow

```bash
# Enter the nix dev shell
just dev
```

### Building and Testing

```bash
# Build the current system configuration
just switch

# Build without applying changes (test mode)
just build

# Build for a specific host
just switch-host sparrowhawk

# Update flake inputs
just update

# Check flake for issues
just check
```

### Development Commands

```bash
# Test configuration changes without rebuilding
just dry-run

# Garbage collection to free disk space
just gc

# Build home manager configuration
just home

# Format Nix files
just format

# Run tests
just test
```

## Making Changes

### 1. Creating Feature Branches

Always create a feature branch for your changes:

```bash
git checkout -b feature/your-feature-name
```

### 2. Testing Changes

Before committing, always test your changes:

```bash
# Check that the flake is valid
just check

# Build the configuration without applying
just build

# If everything looks good, apply the changes
just switch
```

### 3. Commit Guidelines

Commits should follow conventional commit format:

```
type: brief description

Detailed explanation of changes and reasoning.
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code restructuring
- `chore`: Maintenance tasks
- `docs`: Documentation changes

### 4. Creating Pull Requests

```bash
# Push your branch
git push -u origin feature/your-feature-name

# Create a pull request
gh pr create --title "feat: Your feature" --body "Description of changes"
```

## Project Structure Guidelines

### Adding New Modules

1. **NixOS System Modules**: Place in `modules/nixos/`
2. **Home Manager Modules**: Place in `modules/home/`
3. **Desktop Environments**: Place in `modules/nixos/desktop/`

### Adding New Hosts

1. Create directory: `hosts/<architecture>/<hostname>/`
2. Add `default.nix` with host configuration
3. Add `hardware-configuration.nix` (can generate with `nixos-generate-config`)
4. Host will be auto-discovered by flake

### Adding New Users

1. Create directory: `users/<username>/`
2. Add `default.nix` with common user configuration
3. Add `<hostname>.nix` for host-specific user configuration
4. Add user to `modules/nixos/users.nix`

## Testing Guidelines

### Local Testing

```bash
# Run all tests
just test

# Run specific test
just test-name basic-smoke-test
```

### Pre-commit Checks

The repository uses pre-commit hooks that automatically:
- Format Nix files with `nixfmt`
- Run static analysis with `statix`
- Trim trailing whitespace
- Fix end of files

## Code Style

### Nix Files

- Use `nixfmt` for formatting (runs automatically)
- Follow existing patterns in the codebase
- Keep modules focused on single responsibilities
- Use descriptive variable names

### Documentation

- Update relevant documentation when making changes
- Include comments for complex configurations
- Keep README.md up to date with major changes

## Automated Workflows

The repository includes automated workflows for development:

### Quick Feature Development

```bash
# Create a feature issue
/suggest-feature "Your feature description"

# Define requirements
/define <issue-number>

# Create technical design
/design <issue-number>

# Implement the feature
/implement <issue-number>
```

See [WORKFLOW.md](WORKFLOW.md) for detailed information about automated workflows.

## Getting Help

- Check existing issues on GitHub
- Review documentation in `AGENTS.md` for AI agent assistance
- Consult the NixOS manual and wiki
- Ask in NixOS community forums

## Security

- Never commit secrets or passwords
- Use `age` or `sops-nix` for secret management
- Review security implications of configuration changes
- Keep dependencies up to date with `just update`
