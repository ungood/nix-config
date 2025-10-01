# Contributing

This document describes how to build, test, and contribute to this NixOS configuration repository.

## Prerequisites

- NixOS with flakes enabled

```bash
# Enter the nix dev shell
nix develop -c $SHELL
```

## Development Commands

```bash
# Discover all available just commands
just -l
```

## Flake Organization

The organization of this flake is inspired by [Snowfall Lib](https://github.com/snowfallorg/lib)
but does not take a dependency on it for simplicity and because the owner seems to have abandoned
it.

### Module System

Modules are located in the `modules/` directory first by type (`home` or `nixos`) and then by
"role": `modules/<type>/<role>`.

### Host Configuration

Host configuration is found in `hosts/<system>/<hostname>.nix`. Hosts should import role-level
modules and use configuration to specify host-specific options.

### User Configuration

User configuration is found in `users/<username>.nix` and should not import additional modules,
instead just specifying user preferences as configuration. Avoid host-specific configuration if
possible.

### Library Functions

All reusable functions should be defined in the `lib/` directory. This keeps the codebase
organized and makes functions easily discoverable and testable. Functions should not be defined
inline in modules or other configuration files.

## Making Changes

### 1. Creating Feature Branches

Always create a feature branch for your changes:

```bash
git checkout -b feature/your-feature-name
```

### 2. Testing Changes

Follow Test-Driven Development (TDD) approach:

```bash
# 1. Add failing tests first (Red phase)
# Add tests to appropriate files in tests/scripts/modules/

# 2. Run tests to confirm they fail initially
just test

# 3. Implement feature to make tests pass (Green phase)
# 4. Run tests again to confirm they now pass
just test

# 5. Refactor code while keeping tests passing (Refactor phase)
# 6. Run full validation
just test    # Run comprehensive test suite
just build   # Build configuration
```

### 3. Commit Guidelines

Commits should follow conventional commit format:

```
brief description

Detailed explanation of changes and reasoning.
```

Do NOT use prefixes in the commit to indicate type.

### 4. Creating Pull Requests

```bash
# Push your branch
git push -u origin feature/your-feature-name

# Create a pull request
gh pr create --title "Your feature" --body "Description of changes"
```

Do NOT use prefixes to indicate the type of PR. Reference any relevant issues in the PR description.


## Testing Guidelines

### Testing Guidelines
- **Host-Centric Testing**: Tests run within VM with actual host environments
- **Module Test Files**: Module test scripts should live in the same directory as the modules and
follow a naming convention of "module_test.py".

## Code Style

### Nix Files

- Use `nixfmt` for formatting (runs automatically)
- Follow existing patterns in the codebase
- Keep modules focused on single responsibilities
- Use descriptive variable names

### Documentation

- Update relevant documentation when making changes
- Include comments for complex configurations

## Security

- Never commit secrets or passwords
- Store secrets in the private repository github:ungood/secrets or in 1Password.
- Review security implications of configuration changes
- Keep dependencies up to date with `just update`
