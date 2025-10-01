{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  # Auto-discover users from users directory
  usersDir = ../../../users;
  userEntries = builtins.readDir usersDir;
  userDirs = lib.filterAttrs (_name: type: type == "directory") userEntries;

  # Import nixos.nix files directly and add username/group automatically
  systemUsers = lib.mapAttrs (
    username: _:
    let
      nixosConfig = import (usersDir + "/${username}/nixos.nix") { inherit pkgs; };

      finalConfig = nixosConfig // {
        group = username; # Set group to username automatically
        hashedPassword = inputs.secrets.passwords.${username};
      };
    in
    finalConfig
  ) userDirs;

  # Generate user groups
  userGroups = lib.mapAttrs (_username: _: { }) systemUsers;
in
{
  users = {
    mutableUsers = false;
    groups = userGroups;
    users = systemUsers;
  };
}
