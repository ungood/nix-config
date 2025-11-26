@AGENTS.md
- For fetching hashes of packages, use nix-prefetch-url NOT nix-prefetch-github nor trying to build the flake.
- nixos-unified passes a specialArg `flake` to all modules, which contains attributes `config`, `self`, `inputs` (and `rosettaPkgs` in darwin modules).
- Inifinite recursions due to referencing `config` in `imports` is usually caused by a module expecting an `inputs` or `self` argument instead of getting it from the `flake` argument.