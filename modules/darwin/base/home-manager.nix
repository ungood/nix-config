{ inputs, self, ... }:
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {
      inherit inputs self;
    };

    # Map home configurations to Darwin users
    users = {
      ungood.imports = [ (self + "/configurations/home/ungood") ];
    };
  };
}
