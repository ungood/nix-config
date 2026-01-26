{ self, ... }:
{
  # Import developer modules
  imports = [
    self.homeModules.base
    self.homeModules.developer
    self.homeModules.gaming
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
