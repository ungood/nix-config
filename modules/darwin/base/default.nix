{
  inputs,
  pkgs,
  config,
  self,
  ...
}:
{
  imports = [
    inputs.stylix.darwinModules.stylix
    self.sharedModules.fonts
    self.sharedModules.stylix
    ./home-manager.nix
    ./homebrew.nix
    ./nix.nix
    ./system.nix
  ];

  # Enable sudo with Touch ID
  security.pam.services.sudo_local.touchIdAuth = true;

  # Fish shell configuration
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  # This is required for setting the shell to be effective: https://github.com/nix-darwin/nix-darwin/issues/1237
  users.knownUsers = [ "${config.system.primaryUser}" ];

  # Set fish as default shell for the primary user
  users.users.${config.system.primaryUser} = {
    uid = 501;
    shell = pkgs.fish;
  };
}
