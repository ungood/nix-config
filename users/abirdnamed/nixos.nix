{ pkgs, ... }:
{
  # NixOS system user configuration
  isNormalUser = true;
  description = "Brianna";
  extraGroups = [ ];
  shell = pkgs.fish;
}
