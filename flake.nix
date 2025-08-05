{
  description = "NixOS configurations for Jason Walker";

  inputs = {
    # TODO: Use unstable for desktops and stable for servers?
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";

      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Third-party programs, packaged with nix.
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{self, nixpkgs, home-manager, ...}: let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      sparrowhawk = lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit lib;
        };

        modules = [ ./hosts/sparrowhawk ];
      };
    };
  };
}
