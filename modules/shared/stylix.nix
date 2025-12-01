# Shared stylix configuration for NixOS and Darwin.
# This module contains common theme settings; platform-specific modules
# should import their respective stylix module and this shared config.
{ pkgs, ... }:
{
  stylix = {
    enable = true;

    # This scheme is the default for the system, and can be overriden in home manager per user.
    # See: https://tinted-theming.github.io/tinted-gallery/ for a gallery.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";

    fonts = {
      # Use a nerd font for ligatures.
      monospace = {
        package = pkgs.nerd-fonts.dejavu-sans-mono;
        name = "DejaVuSansM Nerd Font Mono";
      };
      # Use the default fonts
      # sans = DejaVu Serif,
      # serif = DejaVu Sans
      # emoji  Noto Color Emoji
    };
  };
}
