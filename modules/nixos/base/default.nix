{ pkgs, ... }:
{
  imports = [
    ./auth.nix
    ./nix.nix
    ./fonts.nix
    ./home-manager.nix
    ./stylix.nix
    ./user-dotfiles.nix
    ./users.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    curl
    neovim
    unzip
    vim
    wget
    wl-clipboard-rs
  ];

  programs.fish.enable = true;
}
