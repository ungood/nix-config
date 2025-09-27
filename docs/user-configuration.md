# User Configuration Guide

This document explains the two-tier user configuration system in this NixOS configuration.

## Overview

Users can be configured in one of two ways:

1. **Centrally Managed** (Default) - Configuration is managed through this repository
2. **Self-Managed** - Users manage their own configuration via a personal dotfiles repository

## Centrally Managed Users

This is the default configuration method. Users without a `dotfilesRepo` field in their configuration are centrally managed.

### How It Works
- Configuration defined in `users/<username>.nix`
- Home-manager settings applied from the central repository
- Changes require admin access to this repository
- All packages and settings controlled centrally

### Example Configuration
```nix
# users/abirdnamed.nix
{ pkgs, ... }:
{
  home = {
    username = "abirdnamed";
    stateVersion = "25.05";
  };

  nixos = {
    isNormalUser = true;
    description = "A Bird";
    extraGroups = [ "networkmanager" ];
    shell = pkgs.fish;
  };
}
```

## Self-Managed Users

Technical users can manage their own configurations using standalone home-manager with a personal dotfiles repository.

### How It Works
- Add `dotfilesRepo` field to user configuration
- User gets standalone home-manager installation
- Configuration managed in personal dotfiles repository
- Changes don't require admin access

### Setup Steps

1. **Create a dotfiles repository** on GitHub with your home-manager configuration:
   ```nix
   # home.nix in your dotfiles repo
   { config, pkgs, ... }:
   {
     home.username = "trafficcone";
     home.homeDirectory = "/home/trafficcone";
     home.stateVersion = "25.05";

     # Your personal packages
     home.packages = with pkgs; [
       htop
       neofetch
     ];

     # Your personal configurations
     programs.git = {
       enable = true;
       userName = "Your Name";
       userEmail = "your.email@example.com";
     };
   }
   ```

2. **Request dotfilesRepo addition** to your user configuration:
   ```nix
   # users/trafficcone.nix
   { pkgs, ... }:
   {
     home = {
       username = "trafficcone";
       stateVersion = "25.05";
     };

     # Enable self-managed configuration
     dotfilesRepo = "https://github.com/trafficcone/dotfiles.git";

     nixos = {
       isNormalUser = true;
       description = "Jayden";
       extraGroups = [ "networkmanager" "wheel" ];
       shell = pkgs.fish;
     };
   }
   ```

3. **After system rebuild**, initialize your configuration:
   ```bash
   hm-init
   ```

### Helper Commands

Self-managed users get these helper commands:

- `hm-init` - Initialize home-manager from your dotfiles repository
- `hm-update` - Update your configuration (pull latest and rebuild)
- `hm-rollback` - Rollback to a previous configuration generation

### Managing Your Configuration

1. **Make changes** in your dotfiles repository
2. **Push changes** to GitHub
3. **Update locally** with `hm-update`

### Example Dotfiles Repository Structure

```
dotfiles/
├── home.nix          # Main configuration
├── flake.nix         # Optional: For flake-based setup
├── modules/          # Optional: Custom modules
│   ├── vim.nix
│   └── shell.nix
└── README.md
```

### Flake-Based Configuration (Advanced)

For more advanced users, you can use a flake-based configuration:

```nix
# flake.nix in your dotfiles repo
{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations."trafficcone" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./home.nix ];
    };
  };
}
```

## Migration Between Tiers

### From Centrally Managed to Self-Managed

1. Create your dotfiles repository with desired configuration
2. Request `dotfilesRepo` addition to your user file
3. After rebuild, run `hm-init`
4. Your central configuration will no longer apply

### From Self-Managed to Centrally Managed

1. Request removal of `dotfilesRepo` from your user file
2. After rebuild, your configuration returns to central management
3. Optional: Archive your dotfiles repository

## Troubleshooting

### Common Issues

**Q: My changes aren't applying after running hm-update**
- Check that you've pushed your changes to the repository
- Verify the repository URL is correct in your user configuration
- Try running `hm-update` with verbose output

**Q: Conflicts with system packages**
- Self-managed packages should complement, not duplicate system packages
- Remove duplicates from your personal configuration

**Q: Helper commands not found**
- Ensure you've logged out and back in after the system rebuild
- Check that your user has `dotfilesRepo` configured

## Best Practices

1. **Keep configurations modular** - Split into logical files
2. **Version control everything** - Use meaningful commit messages
3. **Test changes locally** before pushing
4. **Document your setup** in your dotfiles README
5. **Avoid duplicating** system-wide configurations
