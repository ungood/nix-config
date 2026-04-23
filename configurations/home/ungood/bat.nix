_:
{ pkgs, ... }:
{
  programs = {
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batgrep
      ];
    };

    fish.shellAbbrs = {
      rg = "batgrep";
      cat = "bat --paging=never";
    };
  };
}
