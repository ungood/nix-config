{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
  ];

  # Enable the KDE Plasma Desktop Environment.
  services = {
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
    };

    desktopManager.plasma6.enable = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    kate
  ];
}
