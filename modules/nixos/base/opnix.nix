{ inputs, ... }:
{
  imports = [ inputs.opnix.nixosModules.default ];

  # Configure opnix for 1Password secret management
  opnix = {
    # Environment file should contain: OP_SERVICE_ACCOUNT_TOKEN=<token>
    environmentFile = "/etc/opnix.env";

    # Secrets configuration for user passwords
    # NOTE: Store pre-hashed passwords in 1Password using: mkpasswd -m sha-512
    secrets = {
      # User password hash for ungood
      "ungood-password" = {
        source = ''{{ op://Private/ungood-nixos-password/hashed_password }}'';
        user = "root";
        mode = "0600";
      };

      # User password hash for trafficcone
      "trafficcone-password" = {
        source = ''{{ op://Private/trafficcone-nixos-password/hashed_password }}'';
        user = "root";
        mode = "0600";
      };
    };
  };
}
