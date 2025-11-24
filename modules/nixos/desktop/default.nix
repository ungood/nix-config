{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.onetrue.desktop;
in
{
  options.onetrue.desktop = {
    windowManager = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "plasma"
          "cosmic"
          "hyprland"
          "pantheon"
        ]
      );
      default = null;
      description = "Which window manager/desktop environment to enable";
    };
  };

  # Import all desktop modules unconditionally
  # Each module will check the option and only activate if needed
  imports = [
    ./wayland.nix
    ./flatpak.nix
    ./firefox.nix
    ./bluetooth.nix
    ./printing.nix
    ./1password.nix
  ];

  config = lib.mkMerge [
    # Plasma desktop environment
    (lib.mkIf (cfg.windowManager == "plasma") {
      environment.systemPackages = with pkgs.kdePackages; [
        # Enables the SDDM configuration panel in KDE Config Manager (kcm).
        sddm-kcm
        plasma-thunderbolt
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
    })

    # TODO: Add configurations for other window managers
    # (lib.mkIf (cfg.windowManager == "cosmic") { ... })
    # (lib.mkIf (cfg.windowManager == "hyprland") { ... })
    # (lib.mkIf (cfg.windowManager == "pantheon") { ... })
  ];
}
