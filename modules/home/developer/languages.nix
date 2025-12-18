# Install language servers common to extensions for various editors
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nil
    nixd
  ];
}
