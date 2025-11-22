_: {
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        obsidian-cli = pkgs.callPackage ../../packages/obsidian-cli.nix { };
      };
    };
}
