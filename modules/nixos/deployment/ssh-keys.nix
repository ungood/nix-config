{ config, lib, ... }:
{
  config = lib.mkIf config.onetrue.deployment.enable {
    # Generate deployment SSH key on manager hosts
    systemd.services.generate-deployment-key = lib.mkIf (config.onetrue.deployment.role == "manager") {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        if [ ! -f /etc/nixos/deploy-key ]; then
          ssh-keygen -t ed25519 -N "" -f /etc/nixos/deploy-key -C "colmena-deployment"
          chmod 600 /etc/nixos/deploy-key
          chmod 644 /etc/nixos/deploy-key.pub
        fi
      '';
    };

    # TODO: Configure deployment key acceptance on nodes
    # This will be implemented when we add the actual deployment keys
  };
}
