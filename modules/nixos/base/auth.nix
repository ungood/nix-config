{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.onetrue.auth;

  # Reference to the private secrets flake

  # Helper function to get password from secrets flake

in
{
  options.onetrue.auth = {
    fingerprintAuth = {
      package = mkPackageOption pkgs "fprintd" { };
    };

    sshKeySudo = {
      authorizedUsers = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Users authorized for sudo access via SSH keys";
        example = [ "ungood" ];
      };
    };
  };

  config = {
    # Configure PAM for authentication
    security.pam.services = {
      login = {
        fprintAuth = true;
      };

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
    users.users = lib.genAttrs cfg.sshKeySudo.authorizedUsers (_username: {
      extraGroups = [ "wheel" ];
    });

    # System packages for authentication
    environment.systemPackages = with pkgs; [
      pam_ssh_agent_auth
      cfg.fingerprintAuth.package
    ];
  };
}
