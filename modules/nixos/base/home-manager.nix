{ self, inputs, ... }:
{ ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {
      inherit inputs self;
    };

    # Map home configurations to NixOS users
    users = {
      ungood.imports = [ self.homeConfigurations.ungood ];
      trafficcone.imports = [ self.homeConfigurations.trafficcone ];
      abirdnamed.imports = [ self.homeConfigurations.abirdnamed ];
    };
  };
}
