# Custom NixOS installer ISO using disko-install
{
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # Available host configurations (update when adding new hosts)
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "install-nixos" (builtins.readFile ./install-nixos.sh))
    gum
    disko
  ];

  # Copy the flake source to the ISO for offline installation
  environment.etc."nixos-config".source = lib.cleanSource ../../..;

  services.getty.helpLine = "To install NixOS: sudo install-nixos";

  # Enable SSH for remote installation if needed
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  networking.networkmanager.enable = true;

  image.baseName = lib.mkForce "nixos-installer";
  isoImage = {
    volumeID = lib.mkForce "nixos-installer";
    makeEfiBootable = true;
    makeUsbBootable = true;
  };
}
