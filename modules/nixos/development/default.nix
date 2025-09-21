{ ... }:
{
  imports = [ ];

  programs.git = {
    enable = true;
    lfs.enable = true;
  };
  # Development tools will be added here
  # This role can be expanded with:
  # - Docker/Podman for containerization
  # - Virtual machine management
  # - Development-specific packages
  # - IDE configurations
}
