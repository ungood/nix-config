
# Common configuration across all roles.
{pkgs, lib, ...}: {
  i18n.defaultLocale = "en_US.UTF-8";

  imports = [
    ./desktop/plasma.nix
    ./nix.nix
    ./home-manager.nix
    ./firefox.nix
    ./1password.nix
    ./steam.nix
  ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    vim
    wget
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;    
  };

  programs.fish.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;



}
