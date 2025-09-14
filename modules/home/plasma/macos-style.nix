# macOS-specific styling overrides for KDE Plasma
{
  # Window decoration settings for better global menu integration
  configFile = {
    # Ensure borderless maximized windows for seamless global menu
    "kwinrc"."Windows"."BorderlessMaximizedWindows" = true;

    # Additional window decoration settings for macOS-like appearance
    "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "SF"; # macOS-style window buttons

    # Panel appearance settings
    "plasmashellrc"."PlasmaViews"."panelVisibility" = 0; # Always visible top panel
  };
}
