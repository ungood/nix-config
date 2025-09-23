{
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
    ../../modules/home/common.nix
  ];
}
