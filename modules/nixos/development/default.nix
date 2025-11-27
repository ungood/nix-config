{ ... }:
{
  imports = [
    ./docker.nix
  ];

  # Development role provides system-level requirements for development work.
  # Docker is the primary system-level requirement as it needs kernel support.
  # Most development tools should be added to modules/home/developer/ instead.
}
