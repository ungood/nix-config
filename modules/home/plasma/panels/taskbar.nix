# macOS-style bottom dock (centered and auto-hiding)
{
  location = "bottom";

  # Auto-hide like macOS dock
  hiding = "autohide";

  # Center alignment for macOS dock style
  alignment = "center";

  # Smaller panel for dock-like appearance
  height = 48;

  widgets = [
    # Application launcher (like Launchpad)
    {
      kickoff = {
        icon = "nix-snowflake-white";
      };
    }

    # Task manager for running applications (dock-style)
    "org.kde.plasma.icontasks"
  ];
}
