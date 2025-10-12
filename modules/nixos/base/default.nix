{ pkgs, ... }:
{
  imports = [
    ./auth.nix
    ./fonts.nix
    ./home-manager.nix
    ./nix-index.nix
    ./nix.nix
    ./ssh.nix
    ./stylix.nix
    ./users.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    curl
    gnupg # For gpg to work in git
    neovim
    psmisc # killall, pstree, ...
    tree
    unzip
    vim
    wget
    wl-clipboard-rs
  ];

  programs.fish.enable = true;
}
