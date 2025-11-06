{ pkgs, ... }:
{
  imports = [
    ./codium.nix
    ./direnv.nix
    ./gh.nix
    ./git.nix
    ./language-servers.nix
    ./python.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    devenv
    jq
    just
    ripgrep
  ];
}
