{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable Flatpak
  services.flatpak.enable = true;

  system.activationScripts.flatpak-flathub = lib.stringAfter [ "etc" ] ''
    ${pkgs.flatpak}/bin/flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  '';

  # Install KDE Discover for Flatpak management
  environment.systemPackages = with pkgs.kdePackages; [
    discover
  ];

  # Enable XDG Desktop Portal for proper Flatpak integration
  xdg.portal = {
    enable = true;
    extraPortals = lib.mkIf config.services.desktopManager.plasma6.enable [
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
  };
}
