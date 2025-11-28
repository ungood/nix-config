{ self, ... }:
{
  # Map home configurations to NixOS users
  home-manager.users = {
    ungood.imports = [ (self + "/configurations/home/ungood") ];
    trafficcone.imports = [ (self + "/configurations/home/trafficcone") ];
    abirdnamed.imports = [ (self + "/configurations/home/abirdnamed") ];
  };
}
