{ pkgs, ... }:
{
  imports = [
    ./vscode.nix
    ./devenv.nix
    ./direnv.nix
    ./git.nix
    ./python.nix
    ./television.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    jq
    ripgrep
  ];
}
