_:
{ pkgs, ... }:
{
  imports = [
    ./cursor.nix
    ./devenv.nix
    ./direnv.nix
    ./git.nix
    ./television.nix
    ./vscode.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    jq
    ripgrep
  ];

  programs.uv.enable = true;
}
