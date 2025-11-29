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
    # Set up KDE Plasma face icon (works on both NixOS and Darwin)
    home.file.".face.icon".source = cfg.path;

    # Linux-specific: Grant SDDM permission to the user's home directory
    # Darwin doesn't need this since it doesn't use SDDM
    home.activation.setupSddmAvatar = lib.mkIf pkgs.stdenv.isLinux (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        echo "Setting sddm permissions for user icon"
        run ${pkgs.acl}/bin/setfacl -m u:sddm:x ${config.home.homeDirectory}
      ''
    );
  };
}
