{ pkgs, ... }:
{
  imports = [
    ./xserver.nix
  ];

  # Enable ElementaryOS Pantheon
  services.xserver.desktopManager.pantheon.enable = true;

  environment.pantheon.excludePackages = [
    pkgs.pantheon.elementary-code
    pkgs.pantheon.elementary-mail
    pkgs.pantheon.elementary-photos
    pkgs.pantheon.elementary-tasks
    pkgs.pantheon.elementary-terminal
    pkgs.pantheon.elementary-calendar
  ];
}
