{ pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./fonts.nix
    ./home-manager.nix
    ./auth.nix
    ./sudo.nix
    ./stylix.nix
    ./users.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    curl
    neovim
    unzip
    vim
    wget
  ];

  programs.fish.enable = true;
}
