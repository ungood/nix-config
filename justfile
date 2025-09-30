# Add all changes to git (needed for flake builds)
git-add:
    git add .

# Enter development shell
dev:
    nix develop -c $SHELL

## Build Commands

# Build the new configuration without activating it.
[group('build')]
build: git-add
    nixos-rebuild build --flake .

# Automatic format all files.
[group('build')]
format:
    pre-commit run -a

## Test Commands

# Check flake for issues
[group('test')]
test: git-add
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

## Ops Commands

# Build the new configuration, activate it, and make it the boot default.
[group('ops')]
switch: git-add
    sudo nixos-rebuild switch --flake .

# Build the new configuration and make it the boot default, but  do  not activate it.
[group('ops')]
boot: git-add
    sudo nixos-rebuild boot --flake .

# Switch for a specific host
[group('ops')]
switch-host HOST: git-add
    sudo nixos-rebuild switch --flake .#{{HOST}}

# Update flake inputs
[group('ops')]
update:
    nix flake update

# Garbage collection to free disk space
[group('ops')]
gc:
    sudo nix-collect-garbage -d

## Installer commands

# Build an ISO image of a host.
[group('installer')]
build-installer: git-add
    nix build .#nixosConfigurations.installer.config.system.build.isoImage -L

# Burn a built image to a host
[group('installer')]
burn-installer DEVICE: build-installer
    @echo "WARNING: This will overwrite all data on {{DEVICE}}"
    @read -p "Type 'yes' to confirm: " confirmation; \
    if [ "$$confirmation" = "yes" ]; then \
        echo "Writing ISO to {{DEVICE}}..."; \
        sudo dd if=result/iso/nixos-custom-installer.iso of={{DEVICE}} bs=4M status=progress oflag=sync; \
        echo "ISO written successfully to {{DEVICE}}"; \
    else \
        echo "Operation cancelled."; \
    fi
