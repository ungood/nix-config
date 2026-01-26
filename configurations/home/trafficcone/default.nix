{ self, ... }:
{
  # Import developer modules
  imports = [
    self.homeModules.base
    self.homeModules.developer
    self.nixosModules.gaming
  ];

  # Home-manager configuration
  home = {
    username = "trafficcone";
    stateVersion = "25.05";
  };

  onetrue = {
    avatar.path = ./traffic-cone.png;
  };
}
