{ pkgs, ... }:
{
  imports = [
    ./language-servers.nix
  ];

  # https://nixos.wiki/wiki/VSCodium
  programs = {
    vscode = {
      enable = true;
      # Using VS Codium
      package = pkgs.vscodium.fhs;

      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          # Path Intellisense - Soft dependency of Nix IDE.
          christian-kohler.path-intellisense

          # Nix IDE
          jnoortheen.nix-ide
        ];

        userSettings = {
          "files.autoSave" = "onFocusChange";
          "editor.mouseWheelZoom" = true;
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "window.zoomLevel" = 0;

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd"; # Package nixd should be installed.
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
