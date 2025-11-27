{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
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

  # Configure user account
  users.users.ungood = {
    name = "ungood";
    home = "/Users/ungood";
  };

  # Home Manager configuration for this host
  home-manager.users.ungood = {
    imports = [
      self.homeModules.base
      self.homeModules.developer
    ];

    home.stateVersion = "24.11";
  };

  system.stateVersion = 5;
}
