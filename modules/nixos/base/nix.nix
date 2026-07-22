{ inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ inputs.llm-agents.overlays.shared-nixpkgs ];

  nix = {
    settings = {
      trusted-users = [ "@wheel" ];
    };

    # do garbage collection weekly to keep disk usage low
    gc = {
      dates = "weekly";
    };
  };
}
