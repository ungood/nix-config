{ inputs, self, ... }:
let
  autowire = import "${self}/lib/autowire.nix" { inherit (inputs.nixpkgs) lib; };
  inherit (autowire) forAllNixFiles;

  # Flake context passed to modules via importApply pattern
  # See: https://flake.parts/dogfood-a-reusable-module.html
  flake = { inherit inputs self; };
in
{
  flake = {
    # NixOS and Home modules use importApply pattern for external consumption
    # See: https://flake.parts/dogfood-a-reusable-module.html
    nixosModules = forAllNixFiles "${self}/modules/nixos" (path: import path flake);
    homeModules = forAllNixFiles "${self}/modules/home" (path: import path flake);
    sharedModules = forAllNixFiles "${self}/modules/shared" (path: import path flake);

    overlays = forAllNixFiles "${self}/modules/overlays" import;

    # Auto-discover NixOS configurations from configurations/nixos/*/default.nix
    nixosConfigurations = forAllNixFiles "${self}/configurations/nixos" (
      path:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [ path ];
        specialArgs = {
          inherit inputs self;
        };
      }
    );
  };
}
