_:
{ pkgs, ... }:
{
  imports = [
    ./cursor.nix
    ./devenv.nix
    ./direnv.nix
    ./git.nix
    ./nix-search-tv.nix
    ./television.nix
    ./vscode.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    jq
    ripgrep
    tldr
  ];

  programs = {
    fd.enable = true;
    uv.enable = true;
  };
}
