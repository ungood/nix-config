{ pkgs, ... }:
{
  # Home-manager configuration
  home = {
    username = "abirdnamed";
    stateVersion = "25.05";
  };

  # NixOS system user configuration
  nixos = {
    isNormalUser = true;
    description = "Brianna";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };
}
