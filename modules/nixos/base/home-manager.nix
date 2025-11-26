_: {
  # Map home configurations to NixOS users
  home-manager.users = {
    ungood.imports = [ ../../../configurations/home/ungood ];
    trafficcone.imports = [ ../../../configurations/home/trafficcone ];
    abirdnamed.imports = [ ../../../configurations/home/abirdnamed ];
  };
}
