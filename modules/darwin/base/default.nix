{ ... }:
{
  imports = [
    ./home-manager.nix
    ./nix.nix
    ./stylix.nix
    ./system.nix
  ];

  # Enable sudo with Touch ID
  security.pam.services.sudo_local.touchIdAuth = true;
}
