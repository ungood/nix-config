{ inputs, pkgs, ... }:
{
  imports = [ inputs.stylix.darwinModules.stylix ];

  stylix = {
    enable = true;
    # This scheme is the default for the system, and can be overriden in home manager per user.
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
  };
}
