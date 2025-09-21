_: {

  programs.plasma = {
    enable = true;

    #
    # Some high-level settings:
    #
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    panels = [
      # macOS-style dock at bottom (centered, auto-hiding)
      (import ./panels/taskbar.nix)

      # macOS-style top bar (global menu and system tray)
      (import ./panels/top-bar.nix)
    ];

    #
    # Some mid-level settings:
    #
    shortcuts = {
      ksmserver = {
        "Lock Session" = [
          "Screensaver"
          "Meta+Ctrl+Alt+L"
        ];
      };

      kwin = {
        "Expose" = "Meta+,";
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Window Up" = "Meta+K";
      };
    };

    #
    # Some low-level settings:
    #
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;

      # macOS-style window decorations and behavior
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "SF"; # macOS-style window buttons
      "kwinrc"."Windows"."BorderlessMaximizedWindows" = true; # Global menu integration

      # Panel appearance for macOS-style
      "plasmashellrc"."PlasmaViews"."panelVisibility" = 0; # Always visible top panel

      # Power management settings
      "powermanagementprofilesrc"."AC"."PowerButtonAction" = 32; # Sleep
      "powermanagementprofilesrc"."Battery"."PowerButtonAction" = 32; # Sleep
      "powermanagementprofilesrc"."LowBattery"."PowerButtonAction" = 32; # Sleep

      # Screen lock and sleep timeouts (in milliseconds)
      "powermanagementprofilesrc"."AC"."DimDisplayIdleTimeoutSec" = 270; # 4.5 minutes before dimming
      "powermanagementprofilesrc"."AC"."LockSessionIdleTimeoutSec" = 300; # 5 minutes before lock
      "powermanagementprofilesrc"."AC"."SuspendSessionIdleTimeoutSec" = 1800; # 30 minutes before sleep

      "powermanagementprofilesrc"."Battery"."DimDisplayIdleTimeoutSec" = 270;
      "powermanagementprofilesrc"."Battery"."LockSessionIdleTimeoutSec" = 300;
      "powermanagementprofilesrc"."Battery"."SuspendSessionIdleTimeoutSec" = 1800;

      "powermanagementprofilesrc"."LowBattery"."DimDisplayIdleTimeoutSec" = 270;
      "powermanagementprofilesrc"."LowBattery"."LockSessionIdleTimeoutSec" = 300;
      "powermanagementprofilesrc"."LowBattery"."SuspendSessionIdleTimeoutSec" = 1800;
    };
  };
}
