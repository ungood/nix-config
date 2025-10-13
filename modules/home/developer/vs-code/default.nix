{ pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./platformio.nix
  ];

  # https://nixos.wiki/wiki/VSCodium
  programs = {
    vscode = {
      enable = true;
      # Use the VS Codium package to avoid MS telemtry
      # However, I kind of like having settings sync, so maybe change this...
      package = pkgs.vscodium.fhs;

      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          # Path Intellisense - Soft dependency of Nix IDE.
          christian-kohler.path-intellisense
        ];

        userSettings = {
          "files.autoSave" = "onFocusChange";
          "editor.mouseWheelZoom" = true;
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "window.zoomLevel" = 0;
        };
      };
    };

    fish.shellAbbrs = {
      code = "codium";
    };

    git.ignores = [
      ".vscode"
      ".attach_pid*"
    ];
  };
}
