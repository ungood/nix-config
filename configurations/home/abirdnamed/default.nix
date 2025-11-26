{ flake, ... }:
let
  inherit (flake) self;
in
{
  imports = [
    self.homeModules.base
  ];

  # Home-manager configuration
  home = {
    username = "abirdnamed";
    stateVersion = "25.05";
  };
}
