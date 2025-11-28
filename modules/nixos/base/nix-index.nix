{ inputs, ... }:
{
  # nix-index is usef
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];

  programs.nix-index = {
    enable = true;
  };

  # Installs comma and configures it to use the prebuilt nix-index DB
  programs.nix-index-database.comma.enable = true;
}
