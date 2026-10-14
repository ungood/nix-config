{ inputs, self, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./nvidia.nix
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only

    self.nixosModules.base
    self.nixosModules.desktop
    self.nixosModules.development
    self.nixosModules.gaming
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "sparrowhawk";
    networkmanager.enable = true;
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 2;
    };
  };

  onetrue.auth.authorizedUsers = [ "ungood" ];

  # Paseo host for the work MacBook, reached over SSH. Lingering keeps the
  # daemon and its agents running without a login session.
  users.users.ungood.linger = true;

  home-manager.users.ungood.onetrue.paseo.daemon.enable = true;

  system.stateVersion = "25.05";
}
