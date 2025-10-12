{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    colmena
    deadnix
    gum
    just
    nixfmt-rfc-style
    pre-commit
    statix
  ];
}
