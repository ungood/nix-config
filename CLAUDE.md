@AGENTS.md
- For fetching hashes of packages, use nix-prefetch-url NOT nix-prefetch-github nor trying to build the flake.
- All NixOS, Darwin, and Home Manager modules receive `inputs` and `self` as special arguments via `specialArgs`/`extraSpecialArgs`.