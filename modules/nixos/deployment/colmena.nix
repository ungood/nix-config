{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Define Colmena deployment options
  options.deployment = {
    targetHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Target host for deployment";
    };

    allowLocalDeployment = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow local deployment";
    };

    targetUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Target user for deployment";
    };

    tags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Deployment tags for this host";
    };
  };

  config = lib.mkIf config.onetrue.deployment.enable {
    # Install colmena on manager hosts
    environment.systemPackages = lib.mkIf (config.onetrue.deployment.role == "manager") [
      pkgs.colmena
    ];

    # Override SSH settings for deployment hosts that allow root deployment
    services.openssh.settings = lib.mkIf (config.onetrue.deployment.role == "node") {
      PermitRootLogin = lib.mkForce "prohibit-password";
    };
  };
}
