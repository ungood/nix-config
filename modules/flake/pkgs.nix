_: {
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      # Configure pkgs with overlays and unfree packages
      # _module.args.pkgs = import inputs.nixpkgs {
      #   inherit system;
      #   overlays = lib.attrValues inputs.self.overlays;
      #   config.allowUnfree = true;
      # };

      # Define activate package
      packages.activate = pkgs.writeShellScriptBin "activate" ''
        set -euo pipefail

        # Get the hostname argument if provided, otherwise use current hostname
        HOST="''${1:-$(hostname -s)}"

        # Detect platform and run appropriate activation command
        if [[ "$OSTYPE" == "darwin"* ]]; then
          echo "Activating Darwin configuration for host: $HOST"
          darwin-rebuild switch --flake ".#$HOST"
        elif [[ -f /etc/NIXOS ]]; then
          echo "Activating NixOS configuration for host: $HOST"
          sudo nixos-rebuild switch --flake ".#$HOST"
        else
          echo "Error: Unable to detect platform (expected NixOS or Darwin)"
          exit 1
        fi
      '';
    };
}
