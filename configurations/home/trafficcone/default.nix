{ self, ... }:
{
  # Import developer modules
  imports = [
    self.homeModules.base
    self.homeModules.developer
    self.homeModules.gaming
  ];

  #Git
  programs.git = {
    enable = true;

    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeaSNolAQzMs4wVu3f17hfQz4mYWNl9DS/SMWHpa7cc";
    signing.format = "ssh";
  };

  # Home-manager configuration
  home = {
    username = "trafficcone";
    stateVersion = "25.05";
  };

  onetrue = {
    avatar.path = ./traffic-cone.png;
  };
}
