{
  lib,
  pkgs,
  ...
}:
let
  # Auto-discover users from users directory
  usersDir = ../../../users;
  userFiles = builtins.readDir usersDir;
  nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) userFiles;

  # Find users with dotfilesRepo
  dotfilesUsers = lib.filter (
    username:
    let
      userConfig = import (usersDir + "/${username}.nix") { inherit pkgs lib; };
    in
    userConfig ? dotfilesRepo && userConfig.dotfilesRepo != null
  ) (lib.mapAttrsToList (filename: _: lib.removeSuffix ".nix" filename) nixFiles);
in
{
  config = lib.mkIf (dotfilesUsers != [ ]) {
    # Install standalone home-manager for dotfiles users
    environment.systemPackages = [
      pkgs.home-manager
    ];
  };
}
