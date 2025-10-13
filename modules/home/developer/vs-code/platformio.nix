{ pkgs, ... }:
{
  programs.vscode = {
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # PlatformIO IDE for embedded development
        platformio.platformio-ide
        # C/C++ extension - dependency of PlatformIO
        ms-vscode.cpptools
      ];
    };
  };
}
