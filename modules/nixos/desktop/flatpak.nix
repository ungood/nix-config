{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.onetrue.desktop.flatpak;
in
{
  options.onetrue.desktop.flatpak = {
    enable = lib.mkEnableOption "Flatpak support with KDE Discover";
  };

  config = lib.mkIf cfg.enable {
    # Enable Flatpak
    services.flatpak.enable = true;

    # Configure Flathub repository
    # This is done via systemd service to ensure it runs after Flatpak is initialized
    systemd.services.flatpak-repo-setup = {
      description = "Configure Flathub repository for Flatpak";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
        RemainAfterExit = true;
      };
    };

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
  };
}
