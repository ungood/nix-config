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
    # NixOS, Darwin, and Home modules use importApply pattern for external consumption
    nixosModules = forAllNixFiles "${self}/modules/nixos" (path: import path flake);
    darwinModules = forAllNixFiles "${self}/modules/darwin" (path: import path flake);
    homeModules = forAllNixFiles "${self}/modules/home" (path: import path flake);

    # Shared modules and overlays don't need external flake context
    sharedModules = forAllNixFiles "${self}/modules/shared" import;
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

    # Auto-discover Darwin configurations from configurations/darwin/*/default.nix
    darwinConfigurations = forAllNixFiles "${self}/configurations/darwin" (
      path:
      inputs.nix-darwin.lib.darwinSystem {
        modules = [ path ];
        specialArgs = {
          inherit inputs self;
        };
      }
    );
  };

  # Set activate as default package
  perSystem =
    { self', ... }:
    {
      packages.default = self'.packages.activate;
    };
}
