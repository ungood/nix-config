{ inputs, ... }:
{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    # https://ghostty.org/docs/config/reference
    settings = {
      custom-shader-animation = false;

      # The order of these shaders does matter.
      custom-shader = [
        "${inputs.ghostty-shaders}/cursor_blaze.glsl"
        # This looks pretty cool on a high res display, but not my widescreen monitor :(
        # "${inputs.ghostty-shaders}/tft.glsl"
      ];

      # Nix manages the Ghostty version, so don't let it update itself. Without
      # this, Ghostty asks on macOS whether to enable automatic updates.
      auto-update = "off";

      window-padding-x = 10;
      window-padding-y = 10;
    };
  };

  programs.fish.shellAbbrs.boo = "ghostty +boo";
}
