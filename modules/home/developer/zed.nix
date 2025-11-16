{ ... }:
{
  imports = [
    ./language-servers.nix
  ];

  programs = {
    zed-editor = {
      enable = true;
    };

    fish.shellAbbrs = {
      zed = "zeditor .";
    };
  };
}
