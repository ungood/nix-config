{ pkgs, ... }:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    gum
    just
  ];

  languages.nix.enable = true;

  treefmt = {
    enable = true;
    config.programs = {
      nixfmt.enable = true;
      deadnix.enable = true;
      statix.enable = true;
    };
  };

  git-hooks.hooks = {
    treefmt.enable = true;
    check-eval = {
      enable = true;
      name = "check-eval";
      description = "Evaluate all Nix configurations";
      entry = "just check-eval";
      pass_filenames = false;
      stages = [ "pre-commit" ];
    };
  };
}
