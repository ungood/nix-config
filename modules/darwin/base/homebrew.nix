_: {
  homebrew = {
    enable = true;

    # Auto-update Homebrew and upgrade packages
    onActivation = {
      autoUpdate = true;
      upgrade = true;

      # Remove brews and casks not installed by nix-darwin.
      cleanup = "zap";
    };

    brews = [
      "defaultbrowser"
    ];

    casks = [
      "browsers-software/tap/browsers"
      "beeper"
      "spotify"
    ];
  };
}
