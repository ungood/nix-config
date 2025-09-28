{ pkgs, ... }:
{
  imports = [
    ./auth.nix
    ./nix.nix
    ./fonts.nix
    # ./home-manager.nix  # Disabled - home-manager installed standalone for users
    ./stylix.nix
    ./users.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    curl
    home-manager
    neovim
    unzip
    vim
    wget
    wl-clipboard-rs
  ];

  programs.fish.enable = true;
}
