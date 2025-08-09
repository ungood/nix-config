{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  # Host-specific configurations for sparrowhawk
  imports = [
    inputs.self.homeModules.plasma
  ];

  # Host-specific packages or overrides
  home.packages = with pkgs; [
    # Add sparrowhawk-specific packages here
  ];
}
