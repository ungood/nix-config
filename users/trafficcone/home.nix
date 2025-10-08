{ inputs, ... }:
{
  # Import developer modules
  imports = [
    inputs.self.homeModules.developer
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
