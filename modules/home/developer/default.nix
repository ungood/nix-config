{ pkgs, ... }:
{
  imports = [
    ./vscode.nix
    ./devenv.nix
    ./direnv.nix
    ./gh.nix
    ./git.nix
    ./language-servers.nix
    ./python.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    jq
    ripgrep
  ];
}
