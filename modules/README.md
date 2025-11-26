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

NixOS system configuration modules with [nixos-unified](https://github.com/srid/nixos-unified) autowiring.

#### Available Arguments

NixOS modules receive standard NixOS module arguments plus a special `flake` argument:

**Standard NixOS arguments:**
- `config` - System configuration options
- `pkgs` - Nixpkgs package set
- `lib` - Nixpkgs library functions
- `modulesPath` - Path to NixOS modules

**Special argument (from nixos-unified):**
- `flake` - Contains:
  - `flake.self` - The current flake
  - `flake.inputs` - All flake inputs
  - `flake.config` - Flake-level configuration

**Reference:** https://github.com/srid/nixos-unified/blob/main/nix/modules/flake-parts/lib.nix

#### Example

```nix
{
  flake,
  pkgs,
  lib,
  ...
}:
let
  inherit (flake) inputs;
in
{
  # Use flake.inputs instead of expecting inputs parameter
  environment.systemPackages = [ pkgs.vim ];
}
```

### Home Manager Modules (`modules/home/`)

Home Manager user environment modules with nixos-unified autowiring.

#### Available Arguments

Home Manager modules receive standard Home Manager arguments plus the `flake` special argument:

**Standard Home Manager arguments:**
- `config` - Home configuration options
- `pkgs` - Nixpkgs package set
- `lib` - Nixpkgs library functions
- `osConfig` - NixOS system config (when used as NixOS module)

**Special argument (from nixos-unified):**
- `flake` - Contains:
  - `flake.self` - The current flake
  - `flake.inputs` - All flake inputs
  - `flake.config` - Flake-level configuration

**Reference:** https://github.com/srid/nixos-unified/blob/main/nix/modules/flake-parts/lib.nix

#### Example

```nix
{ flake, ... }:
{
  imports = [
    flake.inputs.plasma-manager.homeModules.plasma-manager
  ];

  programs.plasma.enable = true;
}
```

### Darwin Modules (`modules/darwin/`)

macOS system configuration modules (currently unused).

Darwin modules would receive the same arguments as NixOS modules, plus:
- `flake.rosettaPkgs` - x86_64-darwin nixpkgs for Rosetta compatibility

## Common Patterns

### Accessing Flake Inputs

**Flake-parts modules:**
```nix
{ inputs, ... }: {
  imports = [ inputs.some-input.flakeModule ];
}
```

**NixOS/Home modules:**
```nix
{ flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [ inputs.some-input.nixosModules.default ];
}
```