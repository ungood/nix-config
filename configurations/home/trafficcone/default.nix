{ self, ... }:
{
  # Import developer modules
  imports = [
    self.homeModules.base
    self.homeModules.developer
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
