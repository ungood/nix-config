{ inputs, ... }:
{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    # https://ghostty.org/docs/config/reference
    settings = {
      custom-shader-animation = false;

      # The order of these shaders does matter.
      custom-shader = [
        "${inputs.ghostty-shaders}/cursor_blaze.glsl"
        # This looks pretty cool on a high res display, but not my widescreen monitor :(
        # "${inputs.ghostty-shaders}/tft.glsl"
      ];

      window-padding-x = 10;
      window-padding-y = 10;
    };
  };

  programs.fish.shellAbbrs.boo = "ghostty +boo";
}
