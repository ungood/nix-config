{
  config,
  lib,
  ...
}:
let
  cfg = config.security.authentication;
in
{
  options.security.authentication = {
    fingerprint.driver = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = "Fingerprint reader driver package. If set, enables fingerprint authentication.";
      example = lib.literalExpression "pkgs.libfprint-2-tod1-vfs0090";
    };
  };

  config = {
    # Enable fingerprint authentication if driver is specified
    services.fprintd = lib.mkIf (cfg.fingerprint.driver != null) {
      enable = true;
      tod.enable = true;
      tod.driver = cfg.fingerprint.driver;
    };

    # Configure PAM for login authentication
    # GDM and SDDM will fallback on login PAM configuration automatically
    security.pam.services = {
      # Login authentication (password or fingerprint)
      login = {
        text = lib.mkIf (cfg.fingerprint.driver != null) ''
          # Account management
          account required pam_unix.so

          # Authentication - try fingerprint first, then password
          auth sufficient pam_fprintd.so
          auth required pam_unix.so try_first_pass

          # Password management
          password required pam_unix.so sha512 shadow

          # Session management
          session required pam_unix.so
        '';
      };
    };
  };
}
