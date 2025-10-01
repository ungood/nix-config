{ pkgs, ... }:
{
  imports = [
    ./direnv.nix
    ./gh.nix
    ./git.nix
    ./vs-code/default.nix
  ];

  home.packages = with pkgs; [
    jq
    just
  ];
}
