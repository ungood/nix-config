_: {
  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # do garbage collection weekly to keep disk usage low
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
