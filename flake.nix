{
  description = "NixOS configurations for Jason Walker";

  nixConfig = {
    extra-substituters = [ "https://claude-code.cachix.org" ];
    extra-trusted-public-keys = [
      "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
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

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/ungood/secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      customLib = import ./lib {
        inherit inputs self;
        inherit (nixpkgs) lib;
      };
      lib = nixpkgs.lib // customLib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Auto-import modules
      nixosModules = lib.importDir ./modules/nixos;
      homeModules = lib.importDir ./modules/home;

      # Auto-discover and import all tests from tests directory
      discoverTests =
        dir:
        let
          testFiles = builtins.readDir dir;
          testNames = builtins.attrNames (
            lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) testFiles
          );
        in
        lib.listToAttrs (
          map (
            testFile:
            let
              testName = lib.removeSuffix ".nix" testFile;
            in
            {
              name = testName;
              value = import (dir + "/${testFile}") {
                inherit
                  inputs
                  pkgs
                  lib
                  self
                  ;
              };
            }
          ) testNames
        );
    in
    {
      # Auto-generate system configurations
      nixosConfigurations = lib.flatten (lib.mkHosts ./hosts);

      # Export modules for reuse
      inherit nixosModules homeModules;

      # Development shell from shells/
      devShells.${system}.default = import ./shells/default.nix { inherit lib pkgs; };

      # NixOS testing infrastructure
      checks.${system} = discoverTests ./tests;

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
