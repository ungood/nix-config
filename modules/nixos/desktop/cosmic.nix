{ ... }:
{
  imports = [
    ./wayland.nix
  ];

  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # TODO
  #environment.cosmic.excludePackages = [
  #
  #];
}
