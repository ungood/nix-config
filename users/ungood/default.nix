{
  inputs,
  ...
}:
{
  home = {
    username = "ungood";
    homeDirectory = "/home/ungood";
    stateVersion = "25.05";
  };

  # Import common configuration
  imports = [
    inputs.self.homeModules.common
  ];
}
