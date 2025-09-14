# macOS-style top panel configuration
{
  # Global menu bar at the top with macOS-style positioning
  location = "top";
  # Keep default height (26px) - no change from current

  widgets = [
    # Global menu (application menus)
    "org.kde.plasma.appmenu"

    # Spacer to push system tray to the right
    "org.kde.plasma.marginsseparator"

    # System tray with macOS-style ordering
    {
      systemTray.items = {
        # Configure which items show in system tray - macOS order
        shown = [
          "org.kde.plasma.networkmanagement" # Network (leftmost)
          "org.kde.plasma.bluetooth" # Bluetooth
          "org.kde.plasma.volume" # Volume
          "org.kde.plasma.battery" # Battery
        ];

        # Hide items not needed for macOS-style appearance
        hidden = [
          "org.kde.plasma.clipboard"
          "org.kde.plasma.devicenotifier"
          "org.kde.plasma.notifications"
        ];
      };
    }

    # Clock at far right (macOS position)
    "org.kde.plasma.digitalclock"
  ];
}
