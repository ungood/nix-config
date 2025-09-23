{
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/nixos/base
    ../../../modules/nixos/desktop/plasma.nix
    ../../../modules/nixos/development
    ../../../modules/nixos/gaming
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
