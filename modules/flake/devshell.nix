{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks.flakeModule
  ];

  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      # Configure treefmt for code formatting
      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          deadnix.enable = true;
          statix.enable = true;
        };
      };

      # Configure git hooks
      pre-commit.settings.hooks = {
        treefmt.enable = true;
      };

      # Development shell with all tools
      devShells.default = pkgs.mkShell {
        name = "nix-config";

        packages = [
          pkgs.git-crypt
          pkgs.gum
          pkgs.just
          pkgs.omnix
        ];

        # Include treefmt and git-hooks in the shell
        inputsFrom = [
          config.treefmt.build.devShell
          config.pre-commit.devShell
        ];
      };
    };
}
