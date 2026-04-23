_:
{ pkgs, ... }:
{
  imports = [
    ./claude.nix
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
    gitify
    jq
    ripgrep
  ];
}
