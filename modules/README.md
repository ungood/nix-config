# Modules Directory

This directory contains all reusable modules organized by module type. Each type has different arguments and use cases.

## Module Types

### Flake-Parts Modules (`modules/flake/`)

Standard [flake-parts](https://flake.parts) modules that define flake outputs and per-system configurations.

#### Available Arguments

Flake-parts modules receive arguments based on their scope:

**General module arguments:**
- `config`
- `options`
- `lib`

**Top-level module arguments:**
- `lib` - Nixpkgs library functions
- `config` - Merged configuration from all modules
- `getSystem` - Function to get perSystem config for a system
- `moduleWithSystem` - Access perSystem arguments in top-level
- `withSystem` - Enter a specific system's scope

**perSystem module arguments:**
- `pkgs` - Nixpkgs package set for current system
- `inputs'` - Flake inputs with system pre-selected
- `self'` - Current flake outputs with system pre-selected
- `system` - Current system string (e.g., "x86_64-linux")
- `config` - Merged perSystem configuration
- `lib` - Nixpkgs library functions

**Reference:** https://flake.parts/module-arguments.html

#### Example

```nix
# Top-level flake-parts module
{ inputs, ... }:
{
  perSystem = { config, pkgs, ... }: {
    packages.myPackage = pkgs.callPackage ./package.nix { };
  };
}
```

### NixOS Modules (`modules/nixos/`)

NixOS system configuration modules with auto-discovery from the `configurations/nixos/` directory.

#### Available Arguments

NixOS modules receive standard NixOS module arguments plus special arguments passed via `specialArgs`:

**Standard NixOS arguments:**
- `config` - System configuration options
- `pkgs` - Nixpkgs package set
- `lib` - Nixpkgs library functions
- `modulesPath` - Path to NixOS modules

**Special arguments (via specialArgs):**
- `inputs` - All flake inputs
- `self` - The current flake

#### Example

```nix
{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  environment.systemPackages = [ pkgs.vim ];
}
```

### Home Manager Modules (`modules/home/`)

Home Manager user environment modules with auto-discovery from the `configurations/home/` directory.

#### Available Arguments

Home Manager modules receive standard Home Manager arguments plus special arguments via `extraSpecialArgs`:

**Standard Home Manager arguments:**
- `config` - Home configuration options
- `pkgs` - Nixpkgs package set
- `lib` - Nixpkgs library functions
- `osConfig` - NixOS system config (when used as NixOS module)

**Special arguments (via extraSpecialArgs):**
- `inputs` - All flake inputs
- `self` - The current flake

#### Example

```nix
{ inputs, ... }:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  programs.plasma.enable = true;
}
```

### Darwin Modules (`modules/darwin/`)

macOS system configuration modules using nix-darwin with auto-discovery from the `configurations/darwin/` directory.

#### Available Arguments

Darwin modules receive the same arguments as NixOS modules:

**Standard nix-darwin arguments:**
- `config` - System configuration options
- `pkgs` - Nixpkgs package set
- `lib` - Nixpkgs library functions

**Special arguments (via specialArgs):**
- `inputs` - All flake inputs
- `self` - The current flake

#### Example

```nix
{ inputs, pkgs, lib, ... }:
{
  imports = [ inputs.stylix.darwinModules.stylix ];
  environment.systemPackages = [ pkgs.vim ];

  # Set macOS system defaults
  system.defaults.dock.autohide = true;
}
```

## Common Patterns

### Accessing Flake Inputs

**Flake-parts modules:**
```nix
{ inputs, ... }: {
  imports = [ inputs.some-input.flakeModule ];
}
```

**NixOS/Darwin/Home modules:**
```nix
{ inputs, ... }:
{
  imports = [ inputs.some-input.nixosModules.default ];
}
```