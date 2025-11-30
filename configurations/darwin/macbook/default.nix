{ self, ... }:
{
  imports = [
    self.darwinModules.base
  ];

  # Set the platform for this host
  nixpkgs.hostPlatform = "aarch64-darwin"; # Change to x86_64-darwin for Intel Macs

  # Set primary user for system defaults
  system.primaryUser = "ungood";

  # Home Manager configuration for this host
  home-manager.users.ungood.imports = [ ../../../configurations/home/ungood ];

  programs._1password.enable = true;
  # programs._1password-gui.enable = true; - 1password is installed by work profile already.

  system.stateVersion = 5;
}
