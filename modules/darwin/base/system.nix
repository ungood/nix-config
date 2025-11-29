_: {
  # Set macOS system defaults
  system.defaults = {
    dock = {
      autohide = true;
      magnification = true;
      tilesize = 32;
      largesize = 64;

      static-only = true;

      wvous-tl-corner = 6; # Disable screen corner
      wvous-br-corner = 1; # Disabled
      wvous-tr-corner = 1; # Disabled
      wvous-bl-corner = 1; # Disabled
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      QuitMenuItem = true;
      CreateDesktop = false;
      NewWindowTarget = "Home";

      FXDefaultSearchScope = "SCcf"; # Search current folder
      FXPreferredViewStyle = "clmv"; # Column view

      ShowStatusBar = true;
    };

    menuExtraClock = {
      FlashDateSeparators = false;
      ShowDate = 0; # When Space Allows
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
      ShowSeconds = false;
      ShowAMPM = true;
      IsAnalog = false;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    screencapture = {
      location = "$HOME/Pictures";
      type = "png";
    };

    trackpad = {
      Clicking = true;
      Dragging = true;
      DragLock = false;
    };
  };

  # Post-activation script to apply system settings
  system.activationScripts.postUserActivation.text = ''
    # Use macOS activateSettings to apply changes without killing processes
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
