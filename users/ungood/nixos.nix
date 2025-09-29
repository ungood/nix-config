{ pkgs, ... }:
{
  # NixOS system user configuration
  isNormalUser = true;
  description = "Jason";
  extraGroups = [
    "networkmanager"
    "wheel"
  ];
  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYUd6/nysF5AN7Iv8+2iCd/wWH2F1oSGysDqLaAbQM8"
  ];
  shell = pkgs.fish;
}
