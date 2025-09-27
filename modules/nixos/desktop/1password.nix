# System-wide 1Password configuration
{ lib, ... }:
let
  # Auto-discover users from users directory
  usersDir = ../../../users;
  userFiles = builtins.readDir usersDir;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) userFiles;

  # Extract usernames
  usernames = lib.mapAttrsToList (filename: _: lib.removeSuffix ".nix" filename) nixFiles;
in
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = usernames;
  };

  # TODO: Shell Plugins https://developer.1password.com/docs/cli/shell-plugins/nix/
}
