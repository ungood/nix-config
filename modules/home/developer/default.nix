_:
{ pkgs, ... }:
{
  imports = [
    ./cursor.nix
    ./devenv.nix
    ./direnv.nix
    ./git.nix
    ./nix-search-tv.nix
    ./opencode
    ./python.nix
    ./television.nix
    ./vscode.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    jq
    ripgrep
  ];
}
