{
  inputs,
  lib,
  ...
}:
{
  home = {
    username = "abirdnamed";
    homeDirectory = lib.mkDefault "/home/abirdnamed";
    stateVersion = "25.05";
  };

  # Import common configuration
  imports = [
    inputs.self.homeModules.common
  ];
}
