{pkgs,...}:
{
  programs.vscode = {
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Nix IDE
      jnoortheen.nix-ide
    ];

    userSettings = {
      # Nix IDE
      "nix.enableLanguageServer" = true;
    };
  };
}