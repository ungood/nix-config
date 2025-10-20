{ pkgs, ... }:
{
  imports = [
    ./language-servers.nix
  ];

  programs.zed-editor = {
    enable = true;
  };
}
