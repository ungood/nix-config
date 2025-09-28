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

      # Use password from secrets flake (required for all users)
      finalConfig = baseConfig // {
        hashedPassword = inputs.secrets.passwords.${username};
      };
    in
    finalConfig
  ) userConfigs;

  # Generate user groups
  userGroups = lib.mapAttrs (_username: _: { }) systemUsers;

  # Create systemd services for users with dotfiles
  dotfilesServices = lib.mapAttrs' (
    username: userConfig:
    let
      dotfilesRepo = userConfig.dotfiles or null;
      homeDir = "/home/${username}";
    in
    lib.nameValuePair "dotfiles-${username}" (
      if dotfilesRepo != null then
        {
          description = "Clone dotfiles for ${username}";
          wantedBy = [ "multi-user.target" ];
          after = [
            "network-online.target"
            "systemd-user-sessions.service"
          ];
          wants = [ "network-online.target" ];

          path = [
            pkgs.git
            pkgs.openssh
          ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = username;
            Group = username;
            WorkingDirectory = "~";
          };

          script = ''
            set -euo pipefail

            DOTFILES_DIR="${homeDir}/.dotfiles"

            if [ ! -d "$DOTFILES_DIR" ]; then
              echo "Cloning dotfiles repository for ${username}..."
              git clone "${dotfilesRepo}" "$DOTFILES_DIR"
              echo "Dotfiles cloned successfully to $DOTFILES_DIR"
            else
              echo "Dotfiles directory already exists at $DOTFILES_DIR, skipping clone"
            fi
          '';
        }
      else
        {
          enable = false;
        }
    )
  ) userConfigs;

  # Filter out disabled services
  enabledDotfilesServices = lib.filterAttrs (_: service: service.enable or true) dotfilesServices;

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

  # Systemd services for dotfiles
  systemd.services = enabledDotfilesServices;
}
