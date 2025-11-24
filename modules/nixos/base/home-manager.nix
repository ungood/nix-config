{ flake, lib, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;

  # Auto-discover users from configurations/home directory
  usersDir = ../../../configurations/home;
  userEntries = builtins.readDir usersDir;
  userDirs = lib.filterAttrs (_name: type: type == "directory") userEntries;

  # Import home.nix files directly for home-manager
  homeConfigs = lib.mapAttrs (username: _: import (usersDir + "/${username}/home.nix")) userDirs;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Automatically backup files that home manager replaces.
    backupFileExtension = "hm-backup";

    extraSpecialArgs = {
      inherit inputs;
    };

    sharedModules = [
      inputs.plasma-manager.homeModules.plasma-manager
      self.homeModules.base
    ];

    # Auto-discovered user configurations
    users = homeConfigs;
  };
}
