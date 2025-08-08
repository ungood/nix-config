{
  description = "NixOS configurations for Jason Walker";

  nixConfig = {
    extra-substituters = [ "https://claude-code.cachix.org" ];
    extra-trusted-public-keys = [
      "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
    ];
  };

  inputs = {
    # TODO: Use unstable for desktops and stable for servers?
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager, used for managing user configuration
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

    # Third-party programs, packaged with nix.
    # TODO: Currently not used.
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = {
        sparrowhawk = lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit lib;
          };

          modules = [ ./hosts/sparrowhawk ];
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixfmt-rfc-style
          statix
          pre-commit
        ];

        shellHook = ''
          echo "NixOS Development Environment"
          echo "Available tools:"
          echo "  nixfmt - Format Nix files"
          echo "  statix - Lint Nix files"
          echo "  pre-commit - Git pre-commit hooks"

          if [ ! -f .pre-commit-config.yaml ]; then
            echo "Setting up pre-commit hooks..."
            pre-commit install
          fi
        '';
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
