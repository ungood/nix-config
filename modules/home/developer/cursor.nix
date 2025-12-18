{ pkgs, ... }:
{
  imports = [ ./languages.nix ];

  # Cursor is installed via Homebrew (configured in darwin/base/homebrew.nix)
  home.packages = [ pkgs.code-cursor ];

  programs.fish.shellAbbrs = {
    code = "cursor";
  };
}
