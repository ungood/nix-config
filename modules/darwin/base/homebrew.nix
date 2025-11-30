_: {
  homebrew = {
    enable = true;

    # Auto-update Homebrew and upgrade packages
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };

    brews = [
      "defaultbrowser"
    ];

    casks = [
      "browsers-software/tap/browsers"
      "beeper"
      "ghostty"
      "spotify"
    ];
  };
}
