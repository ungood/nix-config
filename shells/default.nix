{ lib, pkgs, ... }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nixfmt-rfc-style
    statix
    deadnix
    pre-commit
  ];

  shellHook = ''
    echo "NixOS Development Environment"
    echo "Available tools:"
    echo "  nixfmt - Format Nix files"
    echo "  statix - Lint Nix files"
    echo "  deadnix - Remove unused bindings"
    echo "  pre-commit - Git pre-commit hooks"
    echo "  just format - Comprehensive formatting (nixfmt + deadnix)"

    if [ ! -f .pre-commit-config.yaml ]; then
      echo "Setting up pre-commit hooks..."
      pre-commit install
    fi
  '';
}
