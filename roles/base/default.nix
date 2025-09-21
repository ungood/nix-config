{ pkgs, inputs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix

    ../../modules/nixos/nix.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/home-manager.nix
    ../../modules/nixos/opnix.nix
    ../../modules/nixos/stylix.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    curl
    home-manager
    unzip
    vim
    wget
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.fish.enable = true;
}
