{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; [
      {
        name = "${config.home.username}";
        src = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/users/${config.home.username}/fish";
      }
      {
        name = "z";
        inherit (z) src;
      }
    ];
  };
}
