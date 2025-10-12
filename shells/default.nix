{ pkgs, self, ... }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    self.inputs.colmena.packages.${pkgs.system}.colmena
    deadnix
    gum
    just
    nixfmt-rfc-style
    pre-commit
    statix
  ];
}
