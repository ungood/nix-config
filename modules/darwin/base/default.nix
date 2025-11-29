{ self, ... }:
{
  imports = [
    ./home-manager.nix
    ./homebrew.nix
    ./nix.nix
    ./stylix.nix
    ./system.nix

    # Shared configuration between NixOS and Darwin
    self.sharedModules.firefox
  ];

  # Enable sudo with Touch ID
  security.pam.services.sudo_local.touchIdAuth = true;
}
