{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { config, pkgs, ... }:
    {
      treefmt = {
        programs = {
          nixfmt.enable = true;
          deadnix.enable = true;
          statix.enable = true;
        };
      };

      pre-commit = {
        check.enable = true;
        settings = {
          hooks = {
            treefmt.enable = true;
          };
        };
      };

      # Development shell
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # This is used in my justfile. It would be better to make that a standalone package that depends on this.
          gum
          just
        ];
      };

      # Make formatter available
      formatter = config.treefmt.build.wrapper;
    };
}
