{ lib, pkgs, ... }:
let
  package = pkgs.nix-search-tv;
in
{
  programs = {
    nix-search-tv = {
      enable = true;
      inherit package;

      # I don't like the channel configuration in home-manager, so I create my own below.
      enableTelevisionIntegration = false;

      settings.indexes = [
        "nixpkgs"
        "nixos"
        "darwin"
        "home-manager"
        "nur"
      ];
    };

    television.channels =
      let
        path = lib.getExe package;
      in
      {
        nix = {
          metadata = {
            name = "nix";
            description = "Use nix-search-tv to search nix options and packages";
          };

          source.command = "${path} print";
          preview.command = ''${path} preview "{}"'';
        };
      };
  };

  # TODO: Add plasma-manager, etc... to nix-search index
  # TODO: Combine with comma and nix-locate/nix-index?
}
