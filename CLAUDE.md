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

### Building and Testing
```bash
# Build the current system configuration
sudo nixos-rebuild switch --flake .

# Build without applying changes (test mode)
sudo nixos-rebuild build --flake .

# Build for a specific host
sudo nixos-rebuild switch --flake .#sparrowhawk

# Update flake inputs
nix flake update

# Check flake for issues
nix flake check
```

### Development Workflow
```bash
# Enter a development shell with nix tools
nix develop

# Test configuration changes without rebuilding
nixos-rebuild dry-run --flake .

# Garbage collection to free disk space
sudo nix-collect-garbage -d
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
