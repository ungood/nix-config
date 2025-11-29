_: {
  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    settings = {
      # Darwin uses @admin instead of @wheel
      trusted-users = [ "@admin" ];
    };

    # Garbage collection using launchd format for Darwin
    gc = {
      interval = {
        Weekday = 0; # Sunday
      };
    };
  };
}
