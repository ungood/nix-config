{ pkgs, ... }:
{
  imports = [
    ./codium.nix
    ./direnv.nix
    ./gh.nix
    ./git.nix
    ./language-servers.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    jq
    just
  ];
}
