{
  pkgs,
  lib,
  config,
  ...
}:
let
  homeRoot = if pkgs.stdenv.isDarwin then "Users" else "home";
in
{
  # Import all base modules
  imports = [
    ./_1password.nix
    ./avatar.nix
    ./browsers.nix
    ./editor.nix
    ./fastfetch.nix
    ./firefox.nix
    ./helix.nix
    ./nix.nix
    ./nix-index.nix
    ./plasma.nix
    ./ssh.nix
  ];

  programs.home-manager.enable = true;

  # Sensible default for `home.homeDirectory`
  # TODO: I don't really undertand why mkForce is needed here...
  home.homeDirectory = lib.mkForce "/${homeRoot}/${config.home.username}";

  # For macOS, $PATH must contain these.
  home.sessionPath = lib.mkIf pkgs.stdenv.isDarwin [
    "/etc/profiles/per-user/$USER/bin" # To access home-manager binaries
    "/nix/var/nix/profiles/system/sw/bin" # To access nix-darwin binaries
    "/usr/local/bin" # Some macOS GUI programs install here
  ];
}
