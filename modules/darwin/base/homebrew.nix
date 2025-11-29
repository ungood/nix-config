_: {
  homebrew = {
    enable = true;

    # Auto-update Homebrew and upgrade packages
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };

    casks = [
      "beeper"
      "ghostty"
      "spotify"
    ];
  };
}
