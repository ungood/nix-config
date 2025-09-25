{
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.base
    inputs.self.nixosModules.desktop.plasma
    inputs.self.nixosModules.development
    inputs.self.nixosModules.gaming
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

  # OneTrue authentication system
  onetrue.auth.sshKeySudo.authorizedUsers = [ "ungood" ];

  system.stateVersion = "25.05";
}
