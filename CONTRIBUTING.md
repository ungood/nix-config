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

This configuration uses [flake-parts](https://flake.parts) for modular flake organization and [nixos-unified](https://github.com/srid/nixos-unified) for unified NixOS/Darwin/Home Manager configuration.

### Module System

Modules are organized in the `modules/` directory by type:

- **`modules/flake/`** - Flake-parts modules that define flake outputs
- **`modules/nixos/`** - NixOS system configuration modules organized by role
  - `base/` - Core system configuration
  - `desktop/` - Desktop environment (Plasma)
  - `development/` - Development tools
  - `gaming/` - Gaming-specific configuration
- **`modules/home/`** - Home Manager user environment modules
  - `base/` - Core user environment
  - `developer/` - Development-specific user configs

See [modules/README.md](modules/README.md) for detailed information about module arguments and patterns.

### Host Configuration

Host configurations are in `configurations/nixos/<hostname>/`. Hosts import module collections and specify host-specific hardware and network settings.

### User Configuration

User configurations are in `configurations/home/<username>/`. Each user's home configuration imports appropriate home modules and sets user preferences.

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
# Add *_test.py files next to modules in modules/nixos/

# 2. Run tests to confirm they fail initially
just test

# 3. Implement feature to make tests pass (Green phase)
# 4. Run tests again to confirm they now pass
just test

# 5. Refactor code while keeping tests passing (Refactor phase)
# 6. Run full validation
just test    # Run comprehensive test suite (flake check)
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

### Module Testing
- **Test Location**: Module test scripts live in the same directory as modules with naming pattern `*_test.py`
- **Auto-Discovery**: Tests are automatically discovered by `modules/flake/checks.nix`
- **NixOS Modules Only**: Currently only NixOS modules are tested (not home modules)
- **VM Testing**: Tests run in a single NixOS VM with all modules imported
- **Test Format**: Python scripts using the NixOS test framework's `machine` object

### Writing Tests

Place test files next to your modules:
```
modules/nixos/mymodule/
  default.nix
  mymodule_test.py
```

Tests are automatically included in `just test` runs.

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
