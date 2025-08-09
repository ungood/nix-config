# NixOS configuration management commands

# Check flake for issues
check:
    nix flake check

# Build and switch to new configuration
switch:
    sudo nixos-rebuild switch --flake .

# Build configuration without applying changes
build:
    sudo nixos-rebuild build --flake .

# Test configuration changes without rebuilding
dry-run:
    nixos-rebuild dry-run --flake .

# Update flake inputs
update:
    nix flake update

# Garbage collection to free disk space
gc:
    sudo nix-collect-garbage -d

# Enter development shell
dev:
    nix develop

# Build for a specific host
switch-host HOST:
    sudo nixos-rebuild switch --flake .#{{HOST}}

# Build home manager configuration
home:
    home-manager switch --flake .
