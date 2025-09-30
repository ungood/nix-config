# Agent Documentation

This file provides guidance to AI coding agents (like Claude Code) when working with this repository.

In addition to this file, agents should reference the existing documentation, including:
* @README.md
* @CONTRIBUTING.md

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

### Import Conventions
- Prefer `inputs.self.nixosModules.[module]` when importing modules
- Simple modules should be single `.nix` files, not directories with `default.nix`
- All reusable functions must be defined in `lib/` directory, not inline in modules

### Development Guidelines
- Start implementation with failing tests, then make them pass
- Prefer using `just` commands for building and testing
- Read project documentation before implementing features
- Follow existing patterns and conventions in the codebase
- Add tests to appropriate module test files in `tests/scripts/modules/`
- Validate with full test suite (`just test`) before committing
- Run configuration checks (`just check`) and builds (`just build`)
- Never try to override or remove failing tests. Always try to fix the test, and if you cannot, report why.
- Avoid making module argument optional due to missing parameters. Instead add the parameter.
- Do NOT attempt to fix tests by simplifying them or working around the issue. Always attempt to fix the issue.
