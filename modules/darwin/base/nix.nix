_: {
  nix = {
    settings = {
      # Darwin uses @admin instead of @wheel
      allowUnfree = true;
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
