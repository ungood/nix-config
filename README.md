
# One True Nix Config

NixOS configuration repository for managing systems in my home network, using Nix flakes for declarative system configuration management.

## Key Features

- **Automatic module discovery** via custom helper functions in `lib/`
- **Stylix theming** with Gruvbox Dark Pale color scheme
- **KDE Plasma** as the default desktop environment
- **Home-manager integration** at system level
- **Automated workflows** for development (see [docs/WORKFLOW.md](docs/WORKFLOW.md))

## Documentation

- [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) - Development workflow and build instructions
- [docs/AGENTS.md](docs/AGENTS.md) - Information for AI coding agents
- [docs/WORKFLOW.md](docs/WORKFLOW.md) - Automated development workflow documentation

## Inspiration

* https://github.com/ryan4yin/nix-config
* https://github.com/thursdaddy/nixos-config

## Tenets

1. When in doubt, keep it simple.
2. Use the right tool for the job: nix is not for everything.
