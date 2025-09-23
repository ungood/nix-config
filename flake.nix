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
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      customLib = import ./lib {
        inherit inputs;
        inherit (nixpkgs) lib;
      };
      lib = nixpkgs.lib // customLib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    in
    {
      # Auto-generate system configurations
      nixosConfigurations = lib.flatten (lib.mkHosts ./hosts);

      # Auto-generate home configurations
      homeConfigurations = lib.mkUsers ./users;

      # Development shell from shells/
      devShells.${system}.default = import ./shells/default.nix { inherit lib pkgs; };

      # NixOS testing infrastructure
      checks.${system} = import ./tests {
        inherit
          inputs
          pkgs
          lib
          ;
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
