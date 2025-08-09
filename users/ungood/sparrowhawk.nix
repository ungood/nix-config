{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  # Host-specific configurations for sparrowhawk
  imports = [
    inputs.self.homeModules.gnome
    inputs.self.homeModules.plasma.example
  ];

  # Host-specific packages or overrides
  home.packages = with pkgs; [
    # Add sparrowhawk-specific packages here
  ];
}
