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

    # Global settings: appearance and input behavior
    NSGlobalDomain = {
      # Appearance: Dark mode
      AppleInterfaceStyle = "Dark";

      # File extensions
      AppleShowAllExtensions = true;

      # Disable swiping with trackpad to navigate.
      AppleEnableSwipeNavigateWithScrolls = false;

      # Disable auto-corrections
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

    WindowManager = {
      # Disable gaps between tiled windows
      EnableTiledWindowMargins = false;
    };

    # Custom preferences not available as typed options
    CustomUserPreferences = {
      # Disable Siri
      "com.apple.assistant.support" = {
        "Assistant Enabled" = false;
      };
      # Orange accent color and highlight
      "NSGlobalDomain" = {
        AppleAccentColor = 1; # Orange
        AppleHighlightColor = "1.0 0.874510 0.701961 Orange";
      };
    };
  };

  system.activationScripts.activateSettings.text = ''
    # Use macOS activateSettings to apply changes without killing processes
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
