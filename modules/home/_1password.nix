# 1Password home-manager configuration
{
  # Enable 1Password autostart on session launch by creating autostart desktop entry
  xdg.configFile."autostart/1password-autostart.desktop".text = ''
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
}
