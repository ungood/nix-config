{
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Automatically backup files that home manager replaces.
    backupFileExtension = "hm-backup";

    extraSpecialArgs = { inherit inputs; };

    sharedModules = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
      inputs.self.homeModules.common
    ];

    # Simple static user configuration
    users = {
      ungood = import ../../../users/ungood.nix;
      trafficcone = import ../../../users/trafficcone.nix;
      abirdnamed = import ../../../users/abirdnamed.nix;
    };
  };
}
