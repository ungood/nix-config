# Contributing

This document describes how to build, test, and contribute to this NixOS configuration repository.

## Prerequisites

- **Nix Installation**: [Lix](https://lix.systems)

  **For macOS/Linux (non-NixOS):**
  ```bash
  curl -sSf -L https://install.lix.systems/lix | sh -s -- install
  ```

  **For NixOS:**

  This configuration automatically uses Lix via the nixos-module. On first rebuild, you may need to use extra substituters:
  ```bash
  sudo nixos-rebuild switch --flake . \
    --option extra-substituters https://cache.lix.systems \
    --option extra-trusted-public-keys cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=
  ```

- **Development Environment**: [devenv](https://devenv.sh) for development shell
  ```bash
  # Enter the devenv shell
  devenv shell
  ```

## Development Commands

```bash
# Discover all available just commands
just -l
```

## Flake Organization

This configuration uses [flake-parts](https://flake.parts) for modular flake organization.

### Module System

Modules are organized in the `modules/` directory by type:

- **`modules/flake/`** - Flake-parts modules that define flake outputs
- **`modules/nixos/`** - NixOS system configuration modules organized by role
  - `base/` - Core system configuration
  - `desktop/` - Desktop environment (Plasma)
  - `development/` - Development tools (primarily Docker)
  - `gaming/` - Gaming-specific configuration
- **`modules/home/`** - Home Manager user environment modules (cross-platform)
  - `base/` - Core user environment
  - `developer/` - Development-specific user configs

See [modules/README.md](modules/README.md) for detailed information about module arguments and patterns.

### Host Configuration

Host configurations are organized by platform:

- **`configurations/nixos/<hostname>/`** - NixOS host configurations with hardware and network settings

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
just test                    # Run comprehensive test suite (flake check)
just build                   # Build NixOS configuration
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
- **NixOS Modules Only**: Currently only NixOS modules are tested (not home or darwin modules)
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

## Secrets Management

This repository uses [git-crypt](https://github.com/AGWA/git-crypt) to encrypt sensitive files in the `secrets/` directory. Encrypted files are automatically decrypted on checkout when the repository is unlocked.

### Unlocking Secrets

After cloning the repository, unlock secrets using the key stored in 1Password:

```bash
just unlock
```

This requires the 1Password CLI (`op`) to be installed and authenticated.

### Adding New Secrets

1. Add files to the `secrets/` directory
2. Ensure `.gitattributes` covers the file pattern (by default, `secrets/**` is encrypted)
3. Commit normally - git-crypt encrypts automatically

### CI Behavior

CI runs without the git-crypt key. Modules that use secrets detect encrypted files and fall back to safe defaults (e.g., locked user accounts).

## Security

- Secrets are stored encrypted in `secrets/` using git-crypt
- The git-crypt key is stored in 1Password
- Review security implications of configuration changes
- Keep dependencies up to date with `just update`
