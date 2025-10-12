{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
  ];

  environment.systemPackages = [
    # Enables the SDDM configuration panel in KDE Config Manager (kcm).
    pkgs.kdePackages.sddm-kcm
  ];

  # Enable the KDE Plasma Desktop Environment.
  services = {
    displayManager.sddm = {
      enable = true;
      # This does not actually work yet
      # See: https://github.com/sddm/sddm/issues/1830
      autoNumlock = true;
    };

    desktopManager.plasma6.enable = true;
  };
}
