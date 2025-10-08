{ pkgs, ... }:
{
  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    daemon.settings = {
      userland-proxy = false;
      features = {
        buildkit = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    # TODO: maybe these are good programs to use.
    #lazydocker
    #dive
  ];

  users.extraGroups.docker = { };
}
