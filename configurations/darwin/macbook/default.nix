{ self, ... }:
{
  imports = [
    self.darwinModules.base
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "ungood";

  # TODO: Import from self.homeConfigurations
  home-manager.users.ungood.imports = [ ../../../configurations/home/ungood ];

  # TODO: Set _1passwor.enable in a shared module, then override it here?
  programs._1password.enable = true;
  # programs._1password-gui.enable = true; - 1password is installed by work profile already.

  system.stateVersion = 5;
}
