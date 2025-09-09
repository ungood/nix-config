# NixOS configuration management commands

# Add all changes to git (needed for flake builds)
git-add:
    git add .

# Check flake for issues
check: git-add
    nix flake check

# Build and switch to new configuration
switch: git-add
    sudo nixos-rebuild switch --flake .

# Build configuration without applying changes
build: git-add
    sudo nixos-rebuild build --flake .

# Test configuration changes without rebuilding
dry-run: git-add
    nixos-rebuild dry-run --flake .

# Update flake inputs
update:
    nix flake update

# Garbage collection to free disk space
gc:
    sudo nix-collect-garbage -d

# Enter development shell
dev:
    nix develop -c $SHELL

# Build for a specific host
switch-host HOST: git-add
    sudo nixos-rebuild switch --flake .#{{HOST}}

# Build home manager configuration
home: git-add
    home-manager switch --flake .
