{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # Auto-discover users from users directory
  usersDir = ../../../users;
  userFiles = builtins.readDir usersDir;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) userFiles;

  # Import user configurations and extract home config
  homeConfigs = lib.mapAttrs' (
    filename: _:
    let
      username = lib.removeSuffix ".nix" filename;
      userConfig = import (usersDir + "/${filename}") { inherit pkgs lib; };
    in
    {
      name = username;
      value = {
        inherit (userConfig) home;
      };
    }
  ) nixFiles;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Automatically backup files that home manager replaces.
    backupFileExtension = "hm-backup";

    extraSpecialArgs = { inherit inputs; };

    sharedModules = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
      inputs.self.homeModules.common
    ];

    # Auto-discovered user configurations
    users = homeConfigs;
  };
}
