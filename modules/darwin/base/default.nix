{ pkgs, ... }:
{
  imports = [
    ./home-manager.nix
    ./nix.nix
    ./stylix.nix
  ];

  # System defaults for macOS
  system.stateVersion = 5;

  # Enable sudo with Touch ID (updated option name)
  security.pam.services.sudo_local.touchIdAuth = true;

  # Set macOS system defaults
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # Column view
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      # Disable automatic capitalization
      NSAutomaticCapitalizationEnabled = false;
      # Disable smart dashes
      NSAutomaticDashSubstitutionEnabled = false;
      # Disable automatic period substitution
      NSAutomaticPeriodSubstitutionEnabled = false;
      # Disable smart quotes
      NSAutomaticQuoteSubstitutionEnabled = false;
      # Disable auto-correct
      NSAutomaticSpellingCorrectionEnabled = false;
    };
  };

  # Enable fish shell
  programs.fish.enable = true;

  # Common packages for all Darwin systems
  environment.systemPackages = with pkgs; [
    curl
    gnupg
    neovim
    tree
    unzip
    vim
    wget
  ];
}
