{
  pkgs,
  inputs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    # https://ghostty.org/docs/config/reference
    settings = {
      cursor-style = "block";

      # The order of these shaders does matter.
      custom-shader = [
        "${inputs.ghostty-shaders}/cursor_blaze.glsl"
        "${inputs.ghostty-shaders}/tft.glsl"
        "${inputs.ghostty-shaders}/galaxy.glsl"
      ];

      window-padding-x = 10;
      window-padding-y = 10;
    };
  };

  programs.fish.shellAbbrs.boo = "ghostty +boo";
}
