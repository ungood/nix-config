{ inputs, lib, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    # Explicitly allow unfree packages, especially the problematic vscode extension
    allowUnfreePredicate = _pkg: true;
    permittedInsecurePackages = [ ];
  };

  nixpkgs.overlays = [
    (
      final: prev:
      let
        marketplace = inputs.nix-vscode-extensions.extensions.${final.system}.vscode-marketplace;
        # Override the cpptools extension to explicitly mark it as free for our purposes
        marketplaceWithOverrides = marketplace // {
          ms-vscode = (marketplace.ms-vscode or { }) // {
            cpptools =
              if marketplace ? ms-vscode && marketplace.ms-vscode ? cpptools then
                marketplace.ms-vscode.cpptools.overrideAttrs (old: {
                  meta = old.meta // {
                    license = lib.licenses.free;
                  };
                })
              else
                null;
          };
        };
      in
      {
        vscode-extensions = prev.vscode-extensions // marketplaceWithOverrides;
      }
    )
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      trusted-users = [ "@wheel" ];
    };

    # do garbage collection weekly to keep disk usage low
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
