# Agent Documentation

This file provides guidance to AI coding agents (like Claude Code) when working with this repository.

In addition to this file, agents should reference the existing documentation, including:
* @README.md
* @CONTRIBUTING.md

## Infrastructure

This configuration uses **Determinate Nix** on both NixOS and Darwin for:
- Performance improvements (parallel evaluation, lazy trees)
- Enterprise-grade reliability and validation
- Native Linux builder support on macOS

The Determinate module is imported automatically in the NixOS base configuration.

## NixOS Configuration Best Practices

### Module Organization
- Keep modules focused on single responsibilities
- Use `lib.mkOption` for configurable module parameters
- Place hardware-specific configs in appropriate host directories

### Security Considerations
- Avoid hardcoding secrets in configuration files
- Use `age` or `sops-nix` for secret management

### Performance Tips
- Use `programs.nh.enable = true` for faster rebuilds
- Enable `nix.settings.auto-optimise-store = true` for storage efficiency
- Consider using `nix.settings.max-jobs` to limit parallel builds
- Use `boot.tmp.cleanOnBoot = true` for faster boots

## Important Notes for Agents

### Framework and Architecture
- This configuration uses **flake-parts** for modular flake organization
- Uses **nixos-unified** for automatic argument passing to modules
- All NixOS and home modules receive a special `flake` argument containing `self`, `inputs`, and `config`
- See `modules/README.md` for detailed module argument documentation

### Import Conventions
- Use `inputs.self.nixosModules.[module]` when importing NixOS modules in host configs
- Use `inputs.self.darwinModules.[module]` when importing Darwin modules in Darwin host configs
- Use `flake.inputs.[input]` when accessing inputs within modules (not `inputs` directly)
- Simple modules should be single `.nix` files, not directories with `default.nix`
- All reusable functions must be defined in `lib/` directory, not inline in modules

### Module Arguments
- **NixOS/Darwin/Home modules**: Receive `flake` special argument from nixos-unified
- **Flake-parts modules**: Receive standard flake-parts arguments (`inputs`, `self`, `pkgs`, etc.)
- Always declare needed arguments explicitly: `{ flake, lib, pkgs, ... }:` not `args:`
- **Darwin modules**: Have access to `flake.rosettaPkgs` for x86_64-darwin packages on Apple Silicon

### Development Guidelines
- Start implementation with failing tests, then make them pass
- Prefer using `just` commands for building and testing
- Read project documentation before implementing features
- Follow existing patterns and conventions in the codebase
- Add `*_test.py` files next to modules in `modules/nixos/` (auto-discovered)
- Validate with full test suite (`just test`) before committing
- Run configuration checks (`just test`) and builds (`just build` for NixOS, `just build-darwin <host>` for Darwin)
- Never try to override or remove failing tests. Always try to fix the test, and if you cannot, report why.
- Avoid making module argument optional due to missing parameters. Instead add the parameter.
- Do NOT attempt to fix tests by simplifying them or working around the issue. Always attempt to fix the issue.

### Cross-Platform Patterns
- **Maximize Home Manager usage**: Platform-agnostic configuration should live in Home Manager modules
- **Minimal system modules**: NixOS and Darwin modules should only contain platform-specific system configuration
- **Platform detection**: Use `osConfig != null` to detect NixOS vs Darwin in Home Manager modules
- **Conditional imports**: Use `lib.optionals` to conditionally import platform-specific modules
