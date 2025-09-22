{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.security.authentication;
in
{
  options.security.authentication = {
    enableFingerprint = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable fingerprint authentication if hardware is available";
    };
  };

  config = {
    # Enable fingerprint authentication if requested and hardware is available
    services.fprintd = lib.mkIf cfg.enableFingerprint {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-vfs0090;
    };

    # Configure PAM for login authentication
    security.pam.services = {
      # Login authentication (password or fingerprint)
      login = {
        text = lib.mkIf cfg.enableFingerprint ''
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

      # GDM authentication (if using GNOME)
      gdm-password = lib.mkIf cfg.enableFingerprint {
        text = ''
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

      # SDDM authentication (if using KDE Plasma)
      sddm = lib.mkIf cfg.enableFingerprint {
        text = ''
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

    # Auto-enable fingerprint authentication if supported hardware is detected
    # For now, disable by default - can be enabled per-host
    security.authentication.enableFingerprint = lib.mkDefault false;
  };
}
