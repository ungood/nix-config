{ pkgs, ... }:
{
  # NixOS system user configuration
  isNormalUser = true;
  description = "Jayden";
  extraGroups = [ ];
  shell = pkgs.fish;
}
