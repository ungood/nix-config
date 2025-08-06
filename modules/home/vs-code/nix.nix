{pkgs,...}:
{
  home.packages = with pkgs; [
    # Nil Nix language server
    nil
  ];

  programs.vscode = {
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Nix IDE
        jnoortheen.nix-ide
      ];

      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          # check https://github.com/oxalica/nil/blob/main/docs/configuration.md for all options available
          "nil" = {
            "formatting" = {
              "command" = ["nixfmt"];
            };
          };
        };
      };
    };
  };
}