# Custom NixOS installer ISO with embedded configurations
{ inputs, ... }:
let
  system = "x86_64-linux";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    inputs.disko.nixosModules.disko
  ];

  # Include git and other useful tools in the installer
  environment.systemPackages = with pkgs; [
    git
    vim
    parted
    gptfdisk
    cryptsetup
    inputs.disko.packages.${system}.default
  ];

  # Copy flake and configurations to the installer ISO
  environment.etc = {
    "nixos-installer/flake.nix".source = ../flake.nix;
    "nixos-installer/flake.lock".source = ../flake.lock;

    # Copy host configurations
    "nixos-installer/hosts/sparrowhawk/default.nix".source = ../hosts/x86_64-linux/sparrowhawk/default.nix;
    "nixos-installer/hosts/sparrowhawk/hardware-configuration.nix".source = ../hosts/x86_64-linux/sparrowhawk/hardware-configuration.nix;
    "nixos-installer/hosts/sparrowhawk/disko.nix".source = ../hosts/x86_64-linux/sparrowhawk/disko.nix;

    "nixos-installer/hosts/logos/default.nix".source = ../hosts/x86_64-linux/logos/default.nix;
    "nixos-installer/hosts/logos/hardware-configuration.nix".source = ../hosts/x86_64-linux/logos/hardware-configuration.nix;
    "nixos-installer/hosts/logos/disko.nix".source = ../hosts/x86_64-linux/logos/disko.nix;

    # Copy modules
    "nixos-installer/modules".source = ../modules;

    # Copy lib
    "nixos-installer/lib".source = ../lib;

    # Copy users
    "nixos-installer/users".source = ../users;

    # Installation script
    "nixos-installer/install.sh" = {
      source = ./install-script.sh;
      mode = "0755";
    };
  };

  # Create a convenient installer command
  environment.shellAliases = {
    install = "/etc/nixos-installer/install.sh";
  };

  # Add installer instructions to MOTD
  services.getty.helpLine = ''

    ╔════════════════════════════════════════════════════════╗
    ║          NixOS Custom Installer                       ║
    ╠════════════════════════════════════════════════════════╣
    ║  Type 'install' to start the installation wizard      ║
    ║  Type 'sudo -i' to get a root shell                   ║
    ╚════════════════════════════════════════════════════════╝

  '';

  # Enable SSH for remote installation (optional)
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Ensure networking is available
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  # ISO naming
  image.fileName = "nixos-custom-installer.iso";
  isoImage.volumeID = "NIXOS_INSTALLER";
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}