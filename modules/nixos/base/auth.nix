{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.onetrue.auth;
in
{
  # Authentication Strategy
  # ======================
  # Initial Login (TTY, SDDM): Require password authentication only
  # Lock Screen Unlock (KDE): Allow biometric authentication (fingerprint) or password
  # Privileged Operations (sudo):
  #   - Require second factor authentication via SSH agent (hardware key, etc.)
  #   - Fallback to root password if SSH agent unavailable

  options.onetrue.auth = {
    fingerprintAuth = {
      package = mkPackageOption pkgs "fprintd" { };
    };

    authorizedUsers = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Users authorized for sudo access via SSH keys";
      example = [ "ungood" ];
    };
  };

  config = {
    # Configure PAM for authentication
    security.pam.services = {
      # Initial login services - password only
      login.fprintAuth = false;
      sddm.fprintAuth = false;

      # Lock screen - allow biometric authentication
      kde.fprintAuth = lib.mkForce true;

      # Privileged operations - require second factor
      sudo = {
        # SSH key-based authentication
        sshAgentAuth = true;
        # Root password fallback - Default PAM already includes pam_unix.so for password auth
      };
    };

    # Install and enable fprintd for fingerprint auth
    services.fprintd = {
      enable = true;
      inherit (cfg.fingerprintAuth) package;
    };

    # Configure SSH agent authentication for sudo
    security.pam.sshAgentAuth.enable = true;

    # Add authorized users to wheel group for sudo access
    users.users = lib.genAttrs cfg.authorizedUsers (_username: {
      extraGroups = [ "wheel" ];
    });

    # System packages for authentication
    environment.systemPackages = with pkgs; [
      pam_ssh_agent_auth
      cfg.fingerprintAuth.package
    ];
  };
}
