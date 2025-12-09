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
      ungood.imports = [ (self + "/configurations/home/ungood") ];
      trafficcone.imports = [ (self + "/configurations/home/trafficcone") ];
      abirdnamed.imports = [ (self + "/configurations/home/abirdnamed") ];
    };
  };
}
