{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.self.roles.gaming # Gaming workstation role
    ../../../modules/nixos/nvidia
    ../../../modules/nixos/users.nix # User definitions
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
