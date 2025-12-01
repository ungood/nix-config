_: {
  programs = {
    zed-editor = {
      enable = true;

      extensions = [
        "just"
        "nix"
      ];
    };

    fish.shellAbbrs = {
      zed = "zeditor .";
    };
  };
}
