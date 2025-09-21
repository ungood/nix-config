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

# Automatic format all files.
format:
    pre-commit run -a

# Build for a specific host
switch-host HOST: git-add
    sudo nixos-rebuild switch --flake .#{{HOST}}

# Build home manager configuration
home: git-add
    home-manager switch --flake .

# Run all host tests (comprehensive testing)
test: test-hosts

# Run all host tests (each host tests all its modules)
test-hosts: (test-host "sparrowhawk")

# Run specific host test (tests all modules for that host)
test-host HOST: git-add
    @echo "Testing host: {{HOST}}"
    nix build --rebuild .#checks.x86_64-linux.{{HOST}} -L

# Run tests in interactive mode for debugging
test-interactive HOST: git-add
    @echo "Starting interactive test for host: {{HOST}}"
    nix build .#checks.x86_64-linux.{{HOST}}.driverInteractive
    ./result/bin/nixos-test-driver
