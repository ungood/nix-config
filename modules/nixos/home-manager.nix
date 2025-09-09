{
  inputs,
  config,
  lib,
  ...
}:
let
  hostname = config.networking.hostName;
  usersDir = ../../users;
  users = builtins.readDir usersDir;
in
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
      inputs.plasma-manager.homeModules.plasma-manager
    ];

    # Reference user configurations from users directory
    users = lib.listToAttrs (
      lib.mapAttrsToList (
        user: _:
        let
          userDir = usersDir + "/${user}";
          hostFile = userDir + "/${hostname}.nix";
        in
        {
          name = user;
          value = {
            imports = [
              (userDir + "/default.nix") # Common user config
            ]
            ++ lib.optional (builtins.pathExists hostFile) hostFile; # Host-specific config if it exists
          };
        }
      ) (lib.filterAttrs (_: type: type == "directory") users)
    );
  };
}
