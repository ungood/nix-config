{ inputs, self, ... }:
let
  autowire = import ../../lib/autowire.nix { inherit (inputs.nixpkgs) lib; };
  inherit (autowire) forAllNixFiles;
in
{
  flake = {
    nixosModules = forAllNixFiles ../../modules/nixos import;
    darwinModules = forAllNixFiles ../../modules/darwin import;
    homeModules = forAllNixFiles ../../modules/home import;

    # Auto-discover NixOS configurations from configurations/nixos/*/default.nix
    nixosConfigurations = forAllNixFiles ../../configurations/nixos (
      path:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [ path ];
        specialArgs = {
          inherit inputs self;
        };
      }
    );

    # Auto-discover Darwin configurations from configurations/darwin/*/default.nix
    darwinConfigurations = forAllNixFiles ../../configurations/darwin (
      path:
      inputs.nix-darwin.lib.darwinSystem {
        modules = [ path ];
        specialArgs = {
          inherit inputs self;
        };
      }
    );

    # Auto-discover Home Manager configurations from configurations/home/*/default.nix
    homeConfigurations = forAllNixFiles ../../configurations/home (
      path:
      inputs.home-manager.lib.homeManagerConfiguration {
        modules = [ path ];
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
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
