{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd

    self.nixosModules.base
    self.nixosModules.desktop
    self.nixosModules.development
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelParams = [
      "pcie_aspm=off"
      "amdgpu.gpu_recovery=1"
      "pm_debug_messages"
    ];

    initrd.systemd.enable = true;
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
