{
  pkgs,
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
    # Set up KDE Plasma face icon
    home.file.".face.icon".source = cfg.path;

    # Grant SDDM permission to the user's home directory (so it can see the .face.icon)
    home.activation.setupSddmAvatar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Setting sddm permissions for user icon"
      run ${pkgs.acl}/bin/setfacl -m u:sddm:x ${config.home.homeDirectory}
    '';
  };
}
