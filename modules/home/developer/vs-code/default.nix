{ pkgs, ... }:
{
  # Install VS Code without managing configuration
  # Configuration is managed via VS Code Settings Sync
  # Previous VSCodium configuration available in codium.nix (not imported)
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };

    git.ignores = [
      ".vscode"
      ".attach_pid*"
    ];
  };
}
