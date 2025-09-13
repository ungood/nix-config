{ pkgs, ... }:
{

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
      # Windows-like panel at the bottom
      {
        location = "bottom";
        widgets = [
          {
            kickoff = {
              icon = "nix-snowflake-white";
            };
          }

          "org.kde.plasma.icontasks"
        ];
      }
      # Global menu at the top
      {
        location = "top";
        height = 26;
        widgets = [
          "org.kde.plasma.appmenu"
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {
              # Configure which items show in system tray
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
            };
          }
          "org.kde.plasma.digitalclock"
        ];
      }
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
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "SF";
      
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

      # Global menu configuration
      "kwinrc"."Windows"."BorderlessMaximizedWindows" = true;
    };
  };
}
