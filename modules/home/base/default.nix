{
  pkgs,
  lib,
  osConfig ? null,
  ...
}:
let
  # Detect if we're on NixOS (osConfig will be null on Darwin)
  isNixOS = osConfig != null;
in
{
  # Import all base modules
  imports = [
    ./_1password.nix
    ./avatar.nix
    ./editor.nix
    ./fastfetch.nix
    ./firefox.nix
    ./helix.nix
    ./nix.nix
    ./nix-index.nix
    ./ssh.nix
    ./stylix.nix
  ]
  ++ lib.optionals isNixOS [
    # NixOS-only modules (plasma-manager)
    ./plasma.nix
  ];

  programs.home-manager.enable = true;

  # Common packages for all users
  home.packages = with pkgs; [
    spotify
  ];
}
