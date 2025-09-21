{
  inputs,
  ...
}:
{
  home = {
    username = "trafficcone";
    homeDirectory = "/home/trafficcone";
    stateVersion = "25.05";
  };

  # Import common configuration
  imports = [
    inputs.self.homeModules.common
  ];
}
