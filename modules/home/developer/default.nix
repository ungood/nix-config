{ pkgs, ... }:
{
  imports = [
    # TODO: Temporarily removing until I can get unfree to work again! ./vscode.nix
    ./devenv.nix
    ./direnv.nix
    ./gh.nix
    ./git.nix
    ./language-servers.nix
    ./python.nix
    ./television.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    jq
    ripgrep
  ];
}
