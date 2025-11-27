
# One True Nix Config

NixOS configuration for systems in my home network: onetrue.name.

This repository was developed as a way to:
1. learn Nix
2. experiment with agentic coding tools
3. finally motivate myself to rid my home network of Windows.

## Network Information

### Users

* `ungood`: That's me, the de facto network admin for my family.
* `trafficcone`: My son, a burgeoning Linux fanatic.
* `abirdnamed`: My wife, who tolerates our shenanigans.

### Hosts

**NixOS Hosts:**
* `sparrowhawk`: My main gaming PC, but sometimes used by trafficcone or a guest.
* `logos`: Framework 13 laptop shared by everyone in the household.
* `proxmox`: A mini-PC home lab running HA and other things, currently not managed by Nix, but hoping to do so.

**Darwin Hosts:**
* `macbook`: Work laptop running macOS (nix-darwin)

## Documentation

- [CONTRIBUTING.md](CONTRIBUTING.md) - Development workflow and build instructions
- [AGENTS.md](AGENTS.md) - Information for AI coding agents
- [WORKFLOW.md](WORKFLOW.md) - Automated development workflow documentation
- [modules/README.md](modules/README.md) - Module types and argument reference

### Installing

#### Prerequisites: Nix Installation

This configuration uses [Determinate Nix](https://docs.determinate.systems/determinate-nix/).

**Install Determinate Nix on macOS or Linux:**
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
```

#### NixOS Installation

To install a configuration on a new NixOS host, an install ISO can be built using `just build-installer` and
burned to a USB drive with `just burn-installer DEVICE`. Boot the new machine using this drive then
run `sudo install-nixos`. Easy peasy.

#### Darwin (macOS) Installation

After installing Determinate Nix on macOS:
1. Clone this repository
2. Build the configuration: `just build-darwin macbook`
3. Activate it: `just activate-host macbook`

## Architecture

This configuration uses:
- **[flake-parts](https://flake.parts)** - Modular flake framework for organizing outputs
- **[nixos-unified](https://github.com/srid/nixos-unified)** - Unified NixOS/Darwin/Home Manager configuration with automatic argument passing
- **[nix-darwin](https://github.com/nix-darwin/nix-darwin)** - macOS system configuration management
- **Plasma Desktop** - KDE Plasma 6 as the default desktop environment (NixOS only)

### Cross-Platform Strategy

The configuration maximizes code reuse between NixOS and Darwin by:
1. **Home Manager First** - Platform-agnostic configuration lives in Home Manager modules
2. **Minimal System Modules** - NixOS and Darwin modules contain only platform-specific system configuration
3. **Conditional Imports** - Platform detection enables NixOS-only features (like plasma-manager) when appropriate

## Inspiration

* https://github.com/ryan4yin/nix-config
* https://github.com/thursdaddy/nixos-config
* https://github.com/srid/nixos-unified
* https://flake.parts

## Tenets

1. When in doubt, keep it simple.
2. Use the right tool for the job: nix is not for everything.
