{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  # Auto-discover users from users directory
  usersDir = ../../../users;
  userFiles = builtins.readDir usersDir;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) userFiles;

  # Import user configurations (exclude users with dotfilesRepo)
  userConfigs = lib.mapAttrs' (
    filename: _:
    let
      username = lib.removeSuffix ".nix" filename;
      userConfig = import (usersDir + "/${filename}") { inherit pkgs lib; };
      # Only include users without dotfilesRepo (centrally managed users)
      hasDotfilesRepo = userConfig ? dotfilesRepo && userConfig.dotfilesRepo != null;
    in
    {
      name = username;
      value = lib.optionalAttrs (!hasDotfilesRepo) userConfig;
    }
  ) nixFiles;

  # Filter out empty configurations (users with dotfilesRepo)
  filteredUserConfigs = lib.filterAttrs (_: config: config != { }) userConfigs;

  # Extract system user configurations and add username/group automatically
  systemUsers = lib.mapAttrs (
    username: config:
    let
      baseConfig = config.nixos // {
        group = username; # Set group to username automatically
      };

      # Use password from secrets flake (required for all users)
      finalConfig = baseConfig // {
        hashedPassword = inputs.secrets.passwords.${username};
      };
    in
    finalConfig
  ) filteredUserConfigs;

  # Generate user groups
  userGroups = lib.mapAttrs (_username: _: { }) systemUsers;
in
{
  # User configuration
  users = {
    # Enable immutable user management
    mutableUsers = false;

    # Auto-generated user groups
    groups = userGroups;

    # Auto-generated user configurations
    users = systemUsers;
  };
}
