{ lib, inputs }:
let
  # Auto-discover and import all files in a directory with nested structure support
  importDir =
    dir:
    let
      files = lib.attrNames (builtins.readDir dir);
      nixFiles = lib.filter (f: lib.hasSuffix ".nix" f && f != "default.nix") files;
      dirs = lib.filter (f: (builtins.readDir dir).${f} == "directory") files;
    in
    lib.listToAttrs (
      # Import .nix files
      (map (f: {
        name = lib.removeSuffix ".nix" f;
        value = import (dir + "/${f}");
      }) nixFiles)
      ++
        # Import directories
        (map (d: {
          name = d;
          value =
            if builtins.pathExists (dir + "/${d}/default.nix") then
              # If directory has default.nix, import it directly
              import (dir + "/${d}")
            else
              # Otherwise, recursively import the directory contents as nested modules
              importDir (dir + "/${d}");
        }) dirs)
    );

  # Generate nixosConfigurations from hosts/ directory
  mkHosts =
    hostsDir:
    let
      systems = builtins.readDir hostsDir;
      systemConfigs = lib.mapAttrs (
        arch: _:
        let
          archDir = hostsDir + "/${arch}";
          hosts = builtins.readDir archDir;
        in
        lib.mapAttrs (
          host: _:
          lib.nixosSystem {
            system = arch;
            specialArgs = { inherit inputs lib; };
            modules = [ (archDir + "/${host}") ];
          }
        ) (lib.filterAttrs (_: type: type == "directory") hosts)
      ) (lib.filterAttrs (_: type: type == "directory") systems);
    in
    systemConfigs;

  # Generate homeConfigurations from users/ directory
  mkUsers =
    usersDir:
    let
      users = builtins.readDir usersDir;
      # For each user directory, find .nix files that aren't default.nix
      userConfigs = lib.concatLists (
        lib.mapAttrsToList (
          user: _:
          let
            userDir = usersDir + "/${user}";
            userFiles = builtins.readDir userDir;
            hostFiles = lib.filter (f: lib.hasSuffix ".nix" f && f != "default.nix") (lib.attrNames userFiles);
          in
          map (hostFile: {
            name = "${user}@${lib.removeSuffix ".nix" hostFile}";
            value = inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = import inputs.nixpkgs {
                system = "x86_64-linux"; # TODO: Make this dynamic based on host
                config.allowUnfree = true;
              };
              extraSpecialArgs = { inherit inputs lib; };
              modules = [
                (userDir + "/default.nix") # Common user config
                (userDir + "/${hostFile}") # Host-specific config
              ];
            };
          }) hostFiles
        ) (lib.filterAttrs (_: type: type == "directory") users)
      );
    in
    lib.listToAttrs userConfigs;

  # Flatten nested attribute sets (for combining system outputs)
  flatten = attrs: lib.fold lib.recursiveUpdate { } (lib.attrValues attrs);
in
{
  inherit
    importDir
    mkHosts
    mkUsers
    flatten
    ;
}
