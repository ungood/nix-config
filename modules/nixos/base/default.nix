{ pkgs, inputs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix

    ./nix.nix
    ./fonts.nix
    ./home-manager.nix
    ./opnix.nix
    ./stylix.nix
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
