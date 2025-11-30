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

    # Use default fonts: DejaVu Serif, Sans, and Mono. Noto Color Emoji for emojis.

    opacity = {
      terminal = 0.85;
    };
  };
}
