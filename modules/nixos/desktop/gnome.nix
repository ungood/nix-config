{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
  ];

  services.displayManager.gdm.enable = true;

  services.desktopManager.gnome = {
    enable = true;
    games.enable = false;
  };

  environment.gnome.excludePackages = with pkgs; [ ];
}
