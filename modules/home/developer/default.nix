_:
{ pkgs, ... }:
{
  imports = [
    ./claude.nix
    ./devenv.nix
    ./direnv.nix
    ./git.nix
    ./kubernetes.nix
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
