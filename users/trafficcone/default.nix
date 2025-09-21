{
  inputs,
  lib,
  ...
}:
{
  home = {
    username = "trafficcone";
    homeDirectory = lib.mkDefault "/home/trafficcone";
    stateVersion = "25.05";
  };

  # Import common configuration
  imports = [
    inputs.self.homeModules.common
  ];
}
