{ pkgs, ... }:
{
  home.packages = with pkgs; [
    devenv
  ];

  programs.git.ignores = [
    ".devenv*"
    "devenv.local.*"
  ];
}
