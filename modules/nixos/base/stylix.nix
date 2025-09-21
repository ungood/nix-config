{ pkgs, inputs, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  stylix = {
    enable = true;
    # This scheme is the default for the system, and can be overriden in home manager per user.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-pale.yaml";

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
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
