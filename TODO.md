- [ ] Prefer Projects with "Zero Configuration" philosophy and rust
- [ ] Choose:
    - [ ] Desktop Manager
    - [ ] Terminal (that supports Mac&Linux), low configuration
        - [ ] ghostty uses nix as their builder
        - [ ] wezterm is in rust
- [x] Setup an AI agent to help write this package
- [ ] Clean up folder structure and imports (create lib function to importing of a directory)
- [ ] set users.mutableUsers to false (requires setting passwd!)
- [x] automatic linting
- [ ] use unstable nix for desktops, stable for server
- [x] configure numlock
- [ ] nix-direnv integration (or mise or something)
- [ ] some build system (justfile or mise)
- [ ] Better fonts
- [ ] Maybe neovim?
- [ ] Maybe tmux or zellig?
- [ ] use variety for wallpapers
- [ ] Better font-size for vs code
- [ ] Ligatures in terminal and vs code
- [ ] Configure claude to notify when done - cross platform
- [ ] Configure claude to use git (add before checking and creating commits)

## Configuration Review Improvements (2025-09-09)

### High Priority
- [ ] **Enable firewall**: Add `networking.firewall.enable = true;` to `modules/nixos/default.nix`
- [ ] **Add build optimizations**: Enable `auto-optimise-store` in `modules/nixos/nix.nix`
- [ ] **Make system dynamic**: Replace hard-coded system in `lib/default.nix:66`

### Medium Priority
- [ ] **Add module options**: Convert modules to use `mkOption` for better reusability
- [ ] **Consider nh program**: Add `programs.nh.enable = true;` for faster rebuilds
- [ ] **Secret management**: Evaluate `age` or `sops-nix` for sensitive data
- [ ] **Review SSH service**: Decide if OpenSSH daemon should be enabled
