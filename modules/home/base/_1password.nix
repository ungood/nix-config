# 1Password home-manager configuration
{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Enable 1Password autostart on session launch by creating autostart desktop entry (Linux only)
  xdg.configFile."autostart/1password-autostart.desktop" = lib.mkIf pkgs.stdenv.isLinux {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=1Password
      Comment=Password manager and secure wallet
      Icon=1password
      Exec=1password --silent
      StartupNotify=false
      X-KDE-autostart-after=panel
      Categories=Utility;Security;
      Hidden=false
    '';
  };

  # On macOS, create symlink for SSH agent socket from macOS location to standard location
  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    ".1password/agent.sock".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  };

  # Install op-ssh-sign wrapper on macOS that calls the 1Password.app location
  home.packages = lib.optionals pkgs.stdenv.isDarwin [
    (pkgs.writeShellScriptBin "op-ssh-sign" ''
      exec /Applications/1Password.app/Contents/MacOS/op-ssh-sign "$@"
    '')
  ];
}
