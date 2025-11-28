{ ... }:
{
  imports = [
    ./home-manager.nix
    ./nix.nix
    ./stylix.nix
  ];

  # Enable sudo with Touch ID
  security.pam.services.sudo_local.touchIdAuth = true;

  # Set macOS system defaults
  # system.defaults = {
  #   dock = {
  #     autohide = true;
  #     show-recents = false;
  #   };

  #   finder = {
  #     AppleShowAllExtensions = true;
  #     FXPreferredViewStyle = "clmv"; # Column view
  #     ShowPathbar = true;
  #     ShowStatusBar = true;
  #   };

  #   NSGlobalDomain = {
  #     AppleShowAllExtensions = true;
  #     # Disable automatic capitalization
  #     NSAutomaticCapitalizationEnabled = false;
  #     # Disable smart dashes
  #     NSAutomaticDashSubstitutionEnabled = false;
  #     # Disable automatic period substitution
  #     NSAutomaticPeriodSubstitutionEnabled = false;
  #     # Disable smart quotes
  #     NSAutomaticQuoteSubstitutionEnabled = false;
  #     # Disable auto-correct
  #     NSAutomaticSpellingCorrectionEnabled = false;
  #   };
  # };

  # Enable fish shell
  #programs.fish.enable = true;
}
