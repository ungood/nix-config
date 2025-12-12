{ config, ... }: {
  homebrew = {
    enable = true;

    # Auto-update Homebrew and upgrade packages
    onActivation = {
      autoUpdate = true;
      upgrade = true;

      # Remove brews and casks not installed by nix-darwin.
      cleanup = "zap";
    };

    taps = [
      "browsers-software/tap"
    ];

    brews = [
      "defaultbrowser"
    ];

    casks = [
      "browsers"
      "beeper"
      "cursor"
      # Installing firefox via Homebrew as nixpkgs firefox-bin is not available on aarch64-darwin
      "firefox" 
      "spotify"
    ];
  };

  # Source brew shellenv to add Homebrew to PATH
  environment.shellInit = ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';
}
