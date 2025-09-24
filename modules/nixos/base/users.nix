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

  # Reference to the private secrets flake
  secretsFlake = inputs.secrets or null;

  # Helper function to get password from secrets flake
  getPasswordFromSecrets =
    username: if secretsFlake != null then secretsFlake.userPasswords.${username} or null else null;

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
    let
      baseConfig = config.nixos // {
        group = username; # Set group to username automatically
      };

      # Get password from secrets if available, otherwise use hardcoded one
      secretPassword = getPasswordFromSecrets username;

      finalConfig =
        if secretPassword != null then baseConfig // { hashedPassword = secretPassword; } else baseConfig;
    in
    finalConfig
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
