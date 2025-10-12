{
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./deployment.nix
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    inputs.self.nixosModules.base
    inputs.self.nixosModules.desktop.plasma
    inputs.self.nixosModules.development
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "logos";
    networkmanager.enable = true;
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 2;
    };
  };

  onetrue.auth.authorizedUsers = [ "ungood" ];

  system.stateVersion = "25.05";
}
