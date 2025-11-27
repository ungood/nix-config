{ pkgs, ... }:
{
  # Install VS Code (proprietary version)
  # Configuration managed via Settings Sync, not home-manager
  home.packages = [
    # Use FHS version on Linux for better extension compatibility
    # Use regular version on Darwin (FHS not available)
    (if pkgs.stdenv.isLinux then pkgs.vscode.fhs else pkgs.vscode)
  ];

  programs.git.ignores = [
    ".vscode"
    ".attach_pid*"
  ];

  stylix.targets.vscode.enable = true;
}
