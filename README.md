
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

## Bootstrapping

### Install Nix

This configuration uses [Lix](https://lix.systems), a community fork of Nix with better Darwin support
and compatibility with nix-darwin.

```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

### NixOS Installation

To install a configuration on a new NixOS host, an install ISO can be built using `just build-installer` and
burned to a USB drive with `just burn-installer DEVICE`. Boot the new machine using this drive then
run `sudo install-nixos`. Easy peasy.

### MacOS Installation

After installing Nix and cloning this repository:

```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch
```

## References

This project depends on these fine tools:

- **[flake-parts](https://flake.parts)** - Modular flake framework
- **[NixOS](https://nixos.org)** - Declarative Linux distribution
- **[nix-darwin](https://github.com/nix-darwin/nix-darwin)** - Declarative macOS configuration
- **[home-manager](https://github.com/nix-community/home-manager)** - User environment management
- **[nixos-hardware](https://github.com/NixOS/nixos-hardware)** - Hardware-specific configurations
- **[stylix](https://github.com/danth/stylix)** - System-wide theming
- **[plasma-manager](https://github.com/nix-community/plasma-manager)** - KDE Plasma configuration management
- **[disko](https://github.com/nix-community/disko)** - Declarative disk partitioning

### Inspiration

A shout-out to these nix configs that I took as inspiration for building my own:

- https://github.com/ryan4yin/nix-config
- https://github.com/thursdaddy/nixos-config
- https://github.com/srid/nixos-unified
