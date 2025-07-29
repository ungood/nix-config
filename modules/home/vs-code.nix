{pkgs,...}:
{
  # https://nixos.wiki/wiki/VSCodium
  programs.vscode = {
    enable = true;
    # Use the VS Codium package to avoid MS telemtry
    package = pkgs.vscodium.fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
    ];
  };
}
