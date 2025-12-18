_:
{ pkgs, ... }:
{
  programs = {
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batgrep
        batman
      ];
    };

    fish.shellAbbrs = {
      rg = "batgrep";
      man = "batman";
      cat = "bat --paging=never";
    };
  };
}
