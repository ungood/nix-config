# Agent Documentation

This file provides guidance to AI coding agents (like Claude Code) when working with this repository.

## Architecture Overview

- **Flake-based**: Uses `flake.nix` as the entry point with inputs for nixpkgs, home-manager, stylix, and plasma-manager
- **Host-specific configurations**: Each system is defined in `hosts/<architecture>/<hostname>/`
- **Modular structure**: Configuration split into reusable modules in `modules/` directory
- **User management**: User configurations in `users/` directory with home-manager integration

## Module System

The configuration uses automatic module discovery via custom helper functions in `lib/`.

### NixOS Modules (`modules/nixos/`)
- `default.nix` - Common system configuration, imports all other modules
- `desktop/` - Desktop environment configurations (GNOME, KDE Plasma, Hyprland, etc.)
- `nvidia/` - NVIDIA graphics card support
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

This repository includes custom slash commands for common workflows:

### Core Commands
- `/commit [message]` - Create formatted git commit
- `/suggest-feature [description]` - Create GitHub issue for feature suggestion
- `/report-bug [description]` - Create GitHub issue for bug report
- `/define [issue-number]` - Define detailed requirements for GitHub issue
- `/design [issue-number]` - Create technical design for GitHub issue
- `/implement [issue-number]` - Implement feature from GitHub issue design
- `/review-pr [pr-number]` - Review and test pull request

See [WORKFLOW.md](WORKFLOW.md) for detailed documentation on the automated development workflow.

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

## Important Notes for Agents

- Always use the `just` commands for building and testing
- Read project documentation before implementing features
- Follow existing patterns and conventions in the codebase
- Test changes with `just check` before committing
- Use automated workflows for feature development
