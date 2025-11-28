{ inputs, self, ... }:
let
  autowire = import ../../lib/autowire.nix { inherit (inputs.nixpkgs) lib; };
  inherit (autowire) forAllNixFiles;
  inherit (inputs.nixpkgs) lib;
in
{
  flake = {
    # Auto-discover NixOS modules from modules/nixos/*/default.nix
    nixosModules = forAllNixFiles ../../modules/nixos import;

    # Auto-discover Darwin modules from modules/darwin/*/default.nix
    darwinModules = forAllNixFiles ../../modules/darwin import;

    # Auto-discover Home Manager modules from modules/home/*/default.nix
    homeModules = forAllNixFiles ../../modules/home import;
    # Auto-discover NixOS configurations from configurations/nixos/*/default.nix
    nixosConfigurations = forAllNixFiles ../../configurations/nixos (
      path:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [
          path
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = {
                inherit inputs self;
              };
            };
          }
        ];
        specialArgs = {
          inherit inputs self;
        };
      }
    );

    # Auto-discover Darwin configurations from configurations/darwin/*/default.nix
    darwinConfigurations = forAllNixFiles ../../configurations/darwin (
      path:
      inputs.nix-darwin.lib.darwinSystem {
        modules = [
          path
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = {
                inherit inputs self;
              };
            };
          }
        ];
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

  # Expose activate package from nixos-unified
  perSystem =
    { system, ... }:
    {
      packages = {
        inherit (inputs.nixos-unified.packages.${system}) activate;
        default = inputs.nixos-unified.packages.${system}.activate;
      };
    };
}
