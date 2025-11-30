{
  pkgs,
  lib,
  ...
}:
{
  # The homebrew version works in mac better
  # TODO: Install hombrew on linux too.
  home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.browsers ];

  xdg.mimeApps.defaultApplications = lib.mkIf pkgs.stdenv.isLinux {
    "text/html" = [ "software.Browsers.desktop" ];
    "x-scheme-handler/http" = [ "software.Browsers.desktop" ];
    "x-scheme-handler/https" = [ "software.Browsers.desktop" ];
  };

  # On macOS, use defaultbrowser CLI to set Browsers as default
  home.activation.setDefaultBrowser = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      /opt/homebrew/bin/defaultbrowser browsers
    ''
  );
}
