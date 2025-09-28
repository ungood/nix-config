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
check: git-add
    nix flake check --option sandbox false

# Run all host tests (comprehensive testing)
[group('test')]
test: test-hosts

# Run all host tests (each host tests all its modules)
[group('test')]
test-hosts: (test-host "sparrowhawk")

# Run specific host test (tests all modules for that host)
[group('test')]
test-host HOST: git-add
    @echo "Testing host: {{HOST}}"
    nix build .#checks.x86_64-linux.{{HOST}} -L --option sandbox false

# Run tests in interactive mode for debugging
[group('test')]
test-interactive HOST: git-add
    @echo "Starting interactive test for host: {{HOST}}"
    nix build .#checks.x86_64-linux.{{HOST}}.driverInteractive --option sandbox false
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
