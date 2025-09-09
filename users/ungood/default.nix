{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home = {
    username = "ungood";
    homeDirectory = "/home/ungood";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [
    jq
    just
    mangohud
    wezterm
  ];

  programs.home-manager.enable = true;

  # Import common home modules
  imports = [
    inputs.self.homeModules.claude
    inputs.self.homeModules.firefox
    inputs.self.homeModules.fish
    inputs.self.homeModules.wezterm
    inputs.self.homeModules.git
    inputs.self.homeModules.ssh
    inputs.self.homeModules.stylix
    inputs.self.homeModules.vs-code
    inputs.self.homeModules.plasma
  ];
}
