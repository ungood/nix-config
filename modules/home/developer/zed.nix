_: {
  programs = {
    zed-editor = {
      enable = false; # Disabled for now

      extensions = [
        "just"
        "nix"
      ];
    };

    #fish.shellAbbrs = {
    #  zed = "zeditor .";
    #};
  };
}
