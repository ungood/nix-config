{ pkgs, inputs, ... }:
{
  # Import developer modules
  imports = [
    inputs.self.homeModules.developer
    ./claude
    ./git.nix
  ];

  # Home-manager configuration
  home = {
    username = "ungood";
    stateVersion = "25.05";

    packages = with pkgs; [
      wezterm
      zed-editor
    ];
  };
}
