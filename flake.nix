{
  description = "NixOS configurations for Jason Walker";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty-shaders = {
      url = "github:0xhckr/ghostty-shaders";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    omnix.url = "github:juspay/omnix";
  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [
        ./devshell.nix
        # VM-based integration tests disabled pending issue #107
        # ./checks.nix
      ];

      flake =
        let
          autowire = import "${self}/lib/autowire.nix" { inherit (inputs.nixpkgs) lib; };
          inherit (autowire) forAllNixFiles;

          # Flake context passed to modules via importApply pattern
          # See: https://flake.parts/dogfood-a-reusable-module.html
          flake = { inherit inputs self; };
        in
        {
          # NixOS and Home modules use importApply pattern for external consumption
          # See: https://flake.parts/dogfood-a-reusable-module.html
          # TODO: Actually use the importApply function...
          nixosModules = forAllNixFiles "${self}/modules/nixos" (path: import path flake);
          homeModules = forAllNixFiles "${self}/modules/home" (path: import path flake);
          sharedModules = forAllNixFiles "${self}/modules/shared" (path: import path flake);
          homeConfigurations = forAllNixFiles "${self}/configurations/home" (path: import path flake);

          overlays = forAllNixFiles "${self}/modules/overlays" import;

          # Auto-discover NixOS configurations from configurations/nixos/*/default.nix
          # TODO: Migrate to importApply as well.
          nixosConfigurations = forAllNixFiles "${self}/configurations/nixos" (
            path:
            inputs.nixpkgs.lib.nixosSystem {
              modules = [ path ];
              specialArgs = {
                inherit inputs self;
              };
            }
          );

          # Omnix CI configuration
          om = {
            ci.default.omnix = {
              dir = ".";

              # TODO: For now, this is disabled as the github runners do not have enough disk space
              # to build everything.
              steps.build.enable = false;
            };
          };
        };

      perSystem =
        {
          lib,
          system,
          ...
        }:
        {
          # Make our overlay available to the devShell
          # "Flake parts does not yet come with an endorsed module that initializes the pkgs argument.""
          # So we must do this manually; https://flake.parts/overlays#consuming-an-overlay
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = lib.attrValues self.overlays;
            config.allowUnfree = true;
          };
        };
    };
}
