{
  lib,
  config,
  ...
}:
let
  cfg = config.onetrue.avatar;
in
{
  options.onetrue.avatar = {
    path = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to user avatar image (PNG only)";
      example = "/path/to/avatar.png";
    };
  };

  config = lib.mkIf (cfg.path != null) {
    # Set up face icon (used by KDE Plasma on NixOS)
    # TODO: This module should be NixOS-specific since KDE Plasma is not available on Darwin
    home.file.".face.icon".source = cfg.path;

    # Make home directory and avatar file accessible for display managers
    home.activation.setupAvatar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Setting permissions for user avatar"
      chmod +x ${config.home.homeDirectory}
      chmod a+r ${config.home.homeDirectory}/.face.icon
    '';
  };
}
