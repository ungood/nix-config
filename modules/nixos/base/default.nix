{
  inputs,
  pkgs,
  self,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    self.sharedModules.stylix
    ./auth.nix
    ./fonts.nix
    ./home-manager.nix
    ./nix.nix
    ./ssh.nix
    ./users.nix

    # Use Lix - a community fork of Nix with better Darwin support
    # TODO: Re-enable once separateDebugInfo/__structuredAttrs issue is fixed
    # inputs.lix-module.nixosModules.default
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
