{ inputs, self, ... }:
let
  autowire = import "${self}/lib/autowire.nix" { inherit (inputs.nixpkgs) lib; };
  inherit (autowire) forAllNixFiles;
in
{
  flake = {
    nixosModules = forAllNixFiles "${self}/modules/nixos" import;
    darwinModules = forAllNixFiles "${self}/modules/darwin" import;
    homeModules = forAllNixFiles "${self}/modules/home" import;
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
    { pkgs, self', ... }:
    {
      legacyPackages.homeConfigurations = forAllNixFiles "${self}/configurations/home" (
        path:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ path ];
          #pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs self;
          };
        }
      );

      packages.default = self'.packages.activate;
    };
}
