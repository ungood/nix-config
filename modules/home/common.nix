{
  pkgs,
  ...
}:
{
  # Common home-manager configuration shared between users
  programs.home-manager.enable = true;

  # Common packages for all users
  home.packages = with pkgs; [
    jq
    just
    mangohud
    spotify
    wezterm
    zed-editor
  ];

  # Common module imports
  imports = [
    ./claude
    ./firefox.nix
    ./fish.nix
    ./gh
    ./ghostty.nix
    ./git.nix
    ./ssh.nix
    ./stylix.nix
    ./vs-code
    ./plasma
  ];
}
