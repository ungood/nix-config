{ inputs, ... }:
{
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
  ];
  perSystem =
    { self', ... }:
    {
      # Makes activate script available as default package
      # e.g. `nix run .#` is an alias for `nix run .#activate`
      packages.default = self'.packages.activate;

      # Flake inputs we want to update periodically
      # Run: `nix run .#update`.
      nixos-unified = {
        primary-inputs = [
          "nixpkgs"
          "home-manager"
          "nix-darwin"
          "nix-index-database"
        ];
      };
    };
}
