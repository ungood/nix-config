{ pkgs, flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    ./auth.nix
    ./fonts.nix
    ./home-manager.nix
    ./nix.nix
    ./ssh.nix
    ./stylix.nix
    ./users.nix

    # Use Determinate Nix for performance and enterprise features
    inputs.determinate.nixosModules.default
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment = {
    localBinInPath = true;

    systemPackages = with pkgs; [
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
  };

  programs.fish.enable = true;
}
