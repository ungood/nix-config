{pkgs,...}:
{
  imports = [
    ./nix.nix
  ];

  # https://nixos.wiki/wiki/VSCodium
  programs.vscode = {
    enable = true;
    # Use the VS Codium package to avoid MS telemtry
    # However, I kind of like having settings sync, so maybe change this...
    package = pkgs.vscodium.fhs;
    
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Path Intellisense - Soft dependency of Nix IDE.
      christian-kohler.path-intellisense
    ];
  };
}
