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

  # Import user configurations and extract home config for centrally managed users only
  homeConfigs = lib.mapAttrs' (
    filename: _:
    let
      username = lib.removeSuffix ".nix" filename;
      userConfig = import (usersDir + "/${filename}") { inherit pkgs lib; };
      # Only include users without dotfilesRepo (centrally managed users)
      hasDotfilesRepo = userConfig ? dotfilesRepo && userConfig.dotfilesRepo != null;
    in
    {
      name = username;
      value = lib.optionalAttrs (!hasDotfilesRepo) {
        inherit (userConfig) home;
      };
    }
  ) nixFiles;

  # Filter out empty configurations (users with dotfilesRepo)
  filteredHomeConfigs = lib.filterAttrs (_: config: config != { }) homeConfigs;
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
      inputs.plasma-manager.homeModules.plasma-manager
      inputs.self.homeModules.common
    ];

    # Auto-discovered user configurations (only centrally managed users)
    users = filteredHomeConfigs;
  };
}
