# TODO: This is very duplicative across nixos/darwin. Would love to merge.
_: {
  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = false;
    allowBroken = false;
  };

  nix = {
    settings = {
      # Darwin uses @admin instead of @wheel
      trusted-users = [ "@admin" ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # Garbage collection using launchd format for Darwin
    gc = {
      interval = {
        Weekday = 0; # Sunday
      };
    };
  };
}
