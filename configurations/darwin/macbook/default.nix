{ self, ... }:
{
  imports = [
    self.darwinModules.base
  ];

  # Set the platform for this host
  nixpkgs.hostPlatform = "aarch64-darwin"; # Change to x86_64-darwin for Intel Macs

  networking.hostName = "macbook";
  networking.computerName = "macbook";

  # Set primary user for system defaults
  system.primaryUser = "ungood";

  # Home Manager configuration for this host
  home-manager.users.ungood.imports = [ ../../../configurations/home/ungood ];

  system.stateVersion = 5;
}
