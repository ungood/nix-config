{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  # Common home-manager configuration shared between users
  programs.home-manager.enable = true;

  # Common packages for all users
  home.packages = with pkgs; [
    jq
    just
    mangohud
    wezterm
  ];

  # Common module imports
  imports = [
    inputs.self.homeModules.claude
    inputs.self.homeModules.firefox
    inputs.self.homeModules.fish
    inputs.self.homeModules.gh
    inputs.self.homeModules.ghostty
    inputs.self.homeModules.git
    inputs.self.homeModules.ssh
    inputs.self.homeModules.stylix
    inputs.self.homeModules.vs-code
    inputs.self.homeModules.plasma
  ];
}
