{ pkgs, ... }:
{
  programs.steam = {
    enable = pkgs.stdenv.hostPlatform.isx86_64;
    gamescopeSession.enable = pkgs.stdenv.hostPlatform.isx86_64;
  };

  programs.gamemode.enable = pkgs.stdenv.hostPlatform.isx86_64;
}
