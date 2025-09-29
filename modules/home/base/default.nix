{
  pkgs,
  ...
}:
{
  # Import all base modules
  imports = [
    ./_1password.nix
    ./firefox.nix
    ./fish.nix
    ./plasma.nix
    ./ssh.nix
    ./stylix.nix
  ];

  programs.home-manager.enable = true;

  # Common packages for all users
  home.packages = with pkgs; [
    spotify
  ];
}
