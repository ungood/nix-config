{ flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  home-manager = {
    # Use system nixpkgs rather than home-manager's
    useGlobalPkgs = true;
    useUserPackages = true;

    # Pass flake inputs to home-manager modules
    extraSpecialArgs = {
      inherit flake;
    };
  };
}
