# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS configuration repository for Jason Walker's systems, using Nix flakes for declarative system configuration management.

## Architecture

- **Flake-based**: Uses `flake.nix` as the entry point with inputs for nixpkgs, home-manager, stylix, and plasma-manager
- **Host-specific configurations**: Each system is defined in `hosts/<architecture>/<hostname>/`
- **Modular structure**: Configuration split into reusable modules in `modules/` directory
- **User management**: User configurations in `users/` directory with home-manager integration

### Directory Structure

- `flake.nix` - Main flake configuration with auto-discovery
- `lib/` - Helper functions for auto-generating configurations
- `hosts/x86_64-linux/` - Host-specific configurations organized by architecture
- `users/username/` - User configurations with `default.nix` (common) and `hostname.nix` (host-specific)
- `modules/nixos/` - System-wide NixOS modules (includes hardware configs)
- `modules/home/` - User-specific home-manager modules
- `shells/` - Development shell configurations

## Common Development Commands

### Building and Testing (using just)
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

### Development Workflow
```bash
# Enter a development shell with nix tools
just dev

# Test configuration changes without rebuilding
just dry-run

# Garbage collection to free disk space
just gc

# Build home manager configuration
just home
```

## Module System

The configuration uses automatic module discovery via custom helper functions in `lib/`.

### NixOS Modules (`modules/nixos/`)
- `default.nix` - Common system configuration, imports all other modules
- `desktop/` - Desktop environment configurations (GNOME, KDE Plasma, Hyprland, etc.)
- `nvidia/` - NVIDIA graphics card support (moved from hardware/)
- `users.nix` - System user definitions
- `home-manager.nix` - Home Manager integration settings
- `nix.nix` - Nix daemon configuration with flakes enabled
- `stylix.nix` - System-wide theming configuration

### Home Manager Modules (`modules/home/`)
- Application-specific configurations (Firefox, VS Code, Git, etc.)
- Shell configuration (Fish shell)
- Terminal emulator setup (Ghostty)
- Desktop environment user settings

### User Configuration Structure
- `users/<username>/default.nix` - Common user configuration across all hosts
- `users/<username>/<hostname>.nix` - Host-specific user configuration
- Automatically generates `homeConfigurations.<username>@<hostname>`

## Key Configuration Points

- **User**: Primary user is `ungood` with Fish as default shell
- **Theme**: Uses Stylix for consistent theming with Gruvbox Dark Pale color scheme
- **Desktop**: Currently configured for KDE Plasma
- **Package Management**: Unfree packages allowed, uses unstable nixpkgs channel
- **Home Manager**: Integrated at system level with automatic file backups

## Styling and Theming

The configuration uses Stylix for system-wide theming:
- Base16 color scheme: Gruvbox Dark Pale
- Applied to Firefox, terminals, and other applications
- System-level theme can be overridden per-user in home-manager

## Hardware Support

- NVIDIA graphics card support via dedicated hardware module
- EFI boot with systemd-boot loader
- NetworkManager for network configuration

## Claude Code Slash Commands

This repository includes custom slash commands for common NixOS workflows:

### Build & Deploy Commands
- `/build` - Build configuration without applying changes
- `/switch` - Build and apply NixOS configuration
- `/update` - Update flake dependencies
- `/check` - Run flake checks and validation

### Development Commands
- `/format` - Format Nix files using nixfmt
- `/gc` - Clean up old generations and store paths
- `/commit [message]` - Create formatted git commit
- `/review [pattern]` - Review configuration for best practices

### Automated Workflow Commands
- `/ideate [feature-description]` - Start automated development workflow with brainstorming and GitHub issue creation
- `/research [issue-number]` - Trigger research and design phase for GitHub issue
- `/implement [issue-number]` - Trigger implementation phase for designed GitHub issue
- `/review-pr [pr-number]` - Trigger automated review and testing for pull request

See `.claude/WORKFLOW.md` for detailed documentation on the automated development workflow using subagents and GitHub integration.

## NixOS Configuration Best Practices

### Module Organization
- Keep modules focused on single responsibilities
- Use `lib.mkOption` for configurable module parameters
- Import modules in `default.nix` files for automatic discovery
- Place hardware-specific configs in appropriate host directories

### Security Considerations
- Avoid hardcoding secrets in configuration files
- Use `age` or `sops-nix` for secret management
- Enable firewall by default, explicitly open needed ports
- Regularly update dependencies with `just update`

### Performance Tips
- Use `programs.nh.enable = true` for faster rebuilds
- Enable `nix.settings.auto-optimise-store = true` for storage efficiency
- Consider using `nix.settings.max-jobs` to limit parallel builds
- Use `boot.tmp.cleanOnBoot = true` for faster boots
