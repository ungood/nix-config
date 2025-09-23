{
  lib,
  ...
}:
{
  home = {
    username = "ungood";
    homeDirectory = lib.mkDefault "/home/ungood";
    stateVersion = "25.05";
  };

  # Import common configuration
  imports = [
    ../../modules/home/common.nix
  ];
}
