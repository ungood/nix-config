{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    deadnix
    gum
    just
    nixfmt-rfc-style
    pre-commit
    statix
  ];
}
