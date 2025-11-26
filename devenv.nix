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
  };
}
