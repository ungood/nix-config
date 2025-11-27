{ pkgs, ... }:
{
  stylix = {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.inconsolata;
        name = "Inconsolata";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    targets.firefox = {
      enable = true;
      profileNames = [ "default" ];
      firefoxGnomeTheme.enable = false;
    };
  };
}
