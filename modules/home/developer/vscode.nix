{ pkgs, ... }:
{
  # Install VS Code (proprietary version)
  # Configuration managed via Settings Sync, not home-manager
  home.packages = [
    pkgs.vscode.fhs
  ];

  programs.git.ignores = [
    ".vscode"
    ".attach_pid*"
  ];
}
