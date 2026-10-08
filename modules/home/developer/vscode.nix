{ pkgs, ... }:
{
  imports = [ ./languages.nix ];

  # Install VS Code (proprietary version).
  # Settings and extensions are not managed by `programs.vscode`; they are
  # handled by Settings Sync, with settings.json symlinked out of the repo
  # per-user (see configurations/home/ungood/vscode).
  home.packages = [
    # Use FHS version on Linux for better extension compatibility
    # Use regular version on Darwin (FHS not available)
    (if pkgs.stdenv.hostPlatform.isLinux then pkgs.vscode.fhs else pkgs.vscode)
  ];

  programs.git.ignores = [
    ".vscode"
    ".attach_pid*"
  ];

  stylix.targets.vscode.enable = true;
}
