
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

* `sparrowhawk`: My main gaming PC, but sometimes used by trafficcone or a guest.
* `logos`: Framework 13 laptop shared by everyone in the household.
* `proxmox`: A mini-PC home lab running HA and other things, currently not managed by Nix, but hoping to do so.
* TBD: My work laptop, which I expect to be a Macbook unless I can BYOD.

## Documentation

- [CONTRIBUTING.md](CONTRIBUTING.md) - Development workflow and build instructions
- [AGENTS.md](AGENTS.md) - Information for AI coding agents
- [WORKFLOW.md](WORKFLOW.md) - Automated development workflow documentation

### Installing

To install a configuration on a new host, an install ISO can be built using `just build-installer` and
burned to a USB drive with `just burn-installer DEVICE`.  Boot the new machine using this drive then
run `sudo install-nixos`. Easy peasy.

## Inspiration

* https://github.com/ryan4yin/nix-config
* https://github.com/thursdaddy/nixos-config
* https://github.com/snowfallorg/lib

## Tenets

1. When in doubt, keep it simple.
2. Use the right tool for the job: nix is not for everything.
