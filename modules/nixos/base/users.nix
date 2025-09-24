{ pkgs, lib, ... }:
let
  # Auto-discover users from users directory
  usersDir = ../../../users;
  userFiles = builtins.readDir usersDir;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) userFiles;

  # Import user configurations
  userConfigs = lib.mapAttrs' (
    filename: _:
    let
      username = lib.removeSuffix ".nix" filename;
      userConfig = import (usersDir + "/${filename}") { inherit pkgs lib; };
    in
    {
      name = username;
      value = userConfig;
    }
  ) nixFiles;

  # Extract system user configurations and add username/group automatically
  systemUsers = lib.mapAttrs (
    username: config:
    config.nixos
    // {
      group = username; # Set group to username automatically
    }
  ) userConfigs;

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
