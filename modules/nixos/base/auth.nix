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
    enable = mkEnableOption "OneTrue authentication system";

    fingerprintAuth = {
      enable = mkEnableOption "fingerprint authentication";
      package = mkPackageOption pkgs "fprintd" { };
    };

    sshKeySudo = {
      enable = mkEnableOption "SSH key-based sudo authorization";
      authorizedKeys = mkOption {
        type = types.attrsOf (types.listOf types.str);
        default = { };
        description = "SSH public keys authorized for sudo access per user";
        example = {
          ungood = [ "ssh-rsa AAAAB3NzaC1yc2E..." ];
        };
      };
    };

    rootPasswordFallback = {
      enable = mkEnableOption "root password fallback for sudo";
    };

    secretsSource = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to secrets for password management";
    };
  };

  config = mkIf cfg.enable {
    # Configure PAM for authentication
    security.pam.services = {
      login = mkIf cfg.fingerprintAuth.enable {
        fprintAuth = true;
      };

      sudo = mkMerge [
        # SSH key-based authentication
        (mkIf cfg.sshKeySudo.enable {
          sshAgentAuth = true;
        })
        # Root password fallback
        (mkIf cfg.rootPasswordFallback.enable {
          # Default PAM already includes pam_unix.so for password auth
        })
      ];
    };

    # Install and enable fprintd for fingerprint auth
    services.fprintd = mkIf cfg.fingerprintAuth.enable {
      enable = true;
      inherit (cfg.fingerprintAuth) package;
    };

    # Configure SSH agent authentication for sudo
    security.pam.sshAgentAuth.enable = mkIf cfg.sshKeySudo.enable true;

    # System packages for authentication
    environment.systemPackages =
      with pkgs;
      [
        (mkIf cfg.sshKeySudo.enable pam_ssh_agent_auth)
      ]
      ++ optionals cfg.fingerprintAuth.enable [
        cfg.fingerprintAuth.package
      ];
  };
}
