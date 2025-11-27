_: {
  nix = {
    settings = {
      trusted-users = [ "@wheel" ];
    };

    # do garbage collection weekly to keep disk usage low
    gc = {
      dates = "weekly";
    };
  };
}
