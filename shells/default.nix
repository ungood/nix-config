{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nixfmt-rfc-style
    statix
    deadnix
    pre-commit
  ];
}
