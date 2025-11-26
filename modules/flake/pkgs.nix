{ inputs, ... }:
{
  perSystem =
    { lib, system, ... }:
    {
      # Configure pkgs with overlays and unfree packages
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = lib.attrValues inputs.self.overlays;
        config.allowUnfree = true;
      };
    };
}
