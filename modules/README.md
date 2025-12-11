# Modules Directory

This directory contains all reusable modules organized by module type. Modules are auto-discovered and exported via `lib/autowire.nix`.

## Module Architecture

### The `flake` Parameter

NixOS, Darwin, and Home Manager modules in this repository use the **importApply pattern** to support external consumption. Each module receives a `flake` parameter as its first argument, containing this repository's context:

```nix
{ self, inputs, ... }:           # flake: this repository's context
{ config, pkgs, ... }:           # args: standard module arguments
{
  # Module implementation
}
```

The `flake` parameter can be destructured directly to access `self` and `inputs`, or captured with an `@` pattern:

```nix
flake@{ self, inputs, ... }:     # Capture as 'flake' AND destructure
args@{ config, pkgs, ... }:      # Capture as 'args' AND destructure
{
  imports = [ inputs.stylix.nixosModules.stylix ];
}
```

| Parameter | Description |
|-----------|-------------|
| `inputs` | This repository's flake inputs (stylix, home-manager, etc.) |
| `self` | Reference to this flake, for accessing sibling modules |

This pattern ensures modules work correctly whether consumed internally (by this repository's configurations) or externally (by work-config or other flakes).

### Why This Pattern?

Standard NixOS/Darwin/Home module arguments come from the **consuming flake**, not the flake that defines the module. When work-config imports `nix-config.darwinModules.base`, module arguments would refer to work-config's context (missing stylix, plasma-manager, etc.).

The `flake` parameter provides this repository's `inputs` and `self`, which are always available regardless of consumer.

## Module Types

### Flake-Parts Modules (`modules/flake/`)

Internal [flake-parts](https://flake.parts) modules that define flake outputs. These are **not exported** for external use and use standard flake-parts arguments.

#### Available Arguments

**Top-level:**
- `inputs` - Flake inputs
- `self` - Current flake
- `config` - Merged configuration
- `lib` - Nixpkgs library
- `withSystem` - Enter a specific system's scope

**perSystem:**
- `pkgs` - Nixpkgs for current system
- `inputs'` - Inputs with system pre-selected
- `self'` - Outputs with system pre-selected
- `system` - Current system string

**Reference:** https://flake.parts/module-arguments.html

#### Example

```nix
{ inputs, ... }:
{
  perSystem = { pkgs, ... }: {
    packages.myPackage = pkgs.callPackage ./package.nix { };
  };
}
```

### NixOS Modules (`modules/nixos/`)

NixOS system configuration modules exported via `self.nixosModules.*`.

#### Arguments

```nix
{ self, inputs, ... }:           # flake: this repository's context
{ config, pkgs, lib, ... }:      # args: standard NixOS module arguments
```

**Standard NixOS arguments:**
- `config` - System configuration options
- `pkgs` - Nixpkgs package set
- `lib` - Nixpkgs library functions
- `modulesPath` - Path to NixOS modules

**Via `flake` parameter:**
- `inputs` - This repository's flake inputs
- `self` - This flake (for `self.nixosModules.*`)

#### Example

```nix
{ self, inputs, ... }:
{ config, pkgs, lib, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    inputs.nix-index-database.nixosModules.nix-index
  ];

  environment.systemPackages = [ pkgs.vim ];
}
```

### Darwin Modules (`modules/darwin/`)

macOS system configuration modules using nix-darwin, exported via `self.darwinModules.*`.

#### Arguments

```nix
{ self, inputs, ... }:           # flake: this repository's context
{ config, pkgs, lib, ... }:      # args: standard nix-darwin module arguments
```

**Standard nix-darwin arguments:**
- `config` - System configuration options
- `pkgs` - Nixpkgs package set
- `lib` - Nixpkgs library functions

**Via `flake` parameter:**
- `inputs` - This repository's flake inputs
- `self` - This flake (for `self.darwinModules.*`)

#### Example

```nix
{ self, inputs, ... }:
{ config, pkgs, lib, ... }:
{
  imports = [
    inputs.stylix.darwinModules.stylix
    inputs.home-manager.darwinModules.home-manager
  ];

  environment.systemPackages = [ pkgs.vim ];
  system.defaults.dock.autohide = true;
}
```

### Home Manager Modules (`modules/home/`)

Cross-platform user environment modules exported via `self.homeModules.*`.

#### Arguments

```nix
{ self, inputs, ... }:           # flake: this repository's context
{ config, pkgs, lib, ... }:      # args: standard Home Manager module arguments
```

**Standard Home Manager arguments:**
- `config` - Home configuration options
- `pkgs` - Nixpkgs package set
- `lib` - Nixpkgs library functions
- `osConfig` - NixOS/Darwin system config (when used as system module)

**Via `flake` parameter:**
- `inputs` - This repository's flake inputs
- `self` - This flake (for `self.homeModules.*`)

#### Example

```nix
{ self, inputs, ... }:
{ config, pkgs, lib, ... }:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    inputs.nix-index-database.homeModules.nix-index
  ];

  programs.plasma.enable = true;
}
```

### Shared Modules (`modules/shared/`)

Platform-agnostic configuration (fonts, theming) that can be imported by both NixOS and Darwin modules. These also use the `flake` parameter pattern.

## Common Patterns

### Importing Sibling Modules

Use `self` to reference other modules from this repository:

```nix
{ self, inputs, ... }:
{ ... }:
{
  imports = [
    self.nixosModules.base
    self.homeModules.developer
  ];
}
```

### Platform Detection in Home Modules

Use `pkgs.stdenv` for cross-platform Home Manager modules:

```nix
{ ... }:
{ pkgs, lib, ... }:
{
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.linux-only-package
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    pkgs.macos-only-package
  ];
}
```

### Modules Without External Dependencies

Modules that don't need the `flake` argument can ignore it with `{ ... }:`:

```nix
{ ... }:
{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.git ];
}
```

## Auto-Discovery

Modules are automatically discovered by `lib/autowire.nix`:

- Single file modules: `modules/nixos/foo.nix` → `nixosModules.foo`
- Directory modules: `modules/nixos/bar/default.nix` → `nixosModules.bar`
