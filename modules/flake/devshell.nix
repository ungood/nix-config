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
      treefmt = {
        programs = {
          nixfmt.enable = true;
          deadnix.enable = true;
          statix.enable = true;
        };
      };

      pre-commit.settings.hooks = {
        treefmt.enable = true;

        # Run nix flake check on pre-push.
        flake-checks = {
          enable = true;
          stages = [ "pre-push" ];
          entry = "nix flake check";
          pass_filenames = false;
          types = [ "nix" ];
        };
      };

      devShells.default = pkgs.mkShell {
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
