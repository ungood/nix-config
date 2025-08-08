{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
  ];

  # TODO: Use a different terminal?
  environment.systemPackages = with pkgs; [ kitty ];

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
}
