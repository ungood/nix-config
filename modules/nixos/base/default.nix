flake@{ self, inputs, ... }:
{ pkgs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    self.sharedModules.fonts
    self.sharedModules.stylix
    ./auth.nix
    (import ./home-manager.nix flake)
    (import ./nix-index.nix flake)
    ./nix.nix
    ./ssh.nix
    ./users.nix
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
