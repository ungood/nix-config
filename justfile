# List recipes
default:
    @just --list

# Add all changes to git (needed for flake builds)
[group('init')]
git-add:
    git add .

# Unlock encrypted secrets using 1Password
[group('init')]
unlock:
    op document get 7c4alonnyk4je75qnoyjdibs6q | git-crypt unlock -

## Test Commands

# Run all checks (format and eval)
[group('test')]
check:
    nix flake check

# Run specific host test (tests all modules for that host)
[group('test')]
test-host HOST: git-add
    @echo "Testing host: {{HOST}}"
    nix build .#checks.x86_64-linux.{{HOST}} -L

# Run tests in interactive mode for debugging
[group('test')]
test-interactive HOST: git-add
    @echo "Starting interactive test for host: {{HOST}}"
    nix build .#checks.x86_64-linux.{{HOST}}.driverInteractive
    ./result/bin/nixos-test-driver

# Build and run a VM for the specified host
[group('test')]
run HOST: (build-vm HOST)
    @echo "Running VM for host: {{HOST}}"
    ./result/bin/run-{{HOST}}-vm

## Ops Commands

# Format all files
[group('ops')]
format:
    treefmt

# Activate the current system configuration (auto-detects NixOS/Darwin)
[group('ops')]
activate: git-add
    sudo nix run .#activate

# Activate configuration for a specific host (auto-detects NixOS/Darwin)
[group('ops')]
activate-host HOST: git-add
    sudo nix run .#activate {{HOST}}

# Update flake inputs
[group('ops')]
update:
    nix flake update

# Garbage collection to free disk space
[group('ops')]
gc:
    sudo nix-collect-garbage -d

# Verify and repair Nix store integrity
[group('ops')]
repair:
    sudo nix-store --verify --check-contents --repair

## Build Commands

# Build a VM for the specified host
[group('build')]
build-vm HOST: git-add
    @echo "Building VM for host: {{HOST}}"
    nix build .#nixosConfigurations.{{HOST}}.config.system.build.vm

# Build Darwin configuration for the specified host
[group('build')]
build-darwin HOST: git-add
    @echo "Building Darwin configuration for host: {{HOST}}"
    nix build .#darwinConfigurations.{{HOST}}.system

# NixOS Commands

# Build the new configuration without activating it.
[group('nixos')]
build: git-add
    nixos-rebuild build --flake .

# Build the new configuration and make it the boot default, but do not activate it.
[group('nixos')]
boot: git-add
    sudo nixos-rebuild boot --flake .

## Deployment Commands
# TODO: I removed Colmena so this doesn't work right now.

# Deploy to all hosts using Colmena
[group('deploy')]
deploy: git-add
    colmena apply

# Deploy to a specific host
[group('deploy')]
deploy-host HOST: git-add
    colmena apply --on {{HOST}}

# Test deployment without applying changes
[group('deploy')]
deploy-test: git-add
    colmena build

# Show deployment plan for all hosts
[group('deploy')]
deploy-plan: git-add
    colmena build --show-trace

## Installer commands

# Build an ISO image of a host.
[group('installer')]
build-installer: git-add
    nix build .#nixosConfigurations.installer.config.system.build.isoImage -L

# Burn a built image to a host
[group('installer')]
burn-installer DEVICE:
    @echo "WARNING This will overwrite all data on {{DEVICE}}"
    gum confirm "Proceed?" && sudo dd if=result/iso/nixos-installer.iso of={{DEVICE}} bs=4M status=progress oflag=sync;
