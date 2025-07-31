{pkgs,...}:
{
  # https://nixos.wiki/wiki/VSCodium
  programs.vscode = {
    enable = true;
    # Use the VS Codium package to avoid MS telemtry
    # However, I kind of like having settings sync, so maybe change this...
    package = pkgs.vscodium.fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Nix IDE
      jnoortheen.nix-ide
    ];
  };
}
