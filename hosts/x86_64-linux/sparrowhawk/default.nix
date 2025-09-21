{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.gaming # Gaming workstation role
    inputs.self.nixosModules.nvidia
    inputs.self.nixosModules.users # User definitions
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

  system.stateVersion = "25.05";
}
