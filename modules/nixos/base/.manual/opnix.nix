{ inputs, ... }:
{
  imports = [ inputs.opnix.nixosModules.default ];

  # Configure opnix for 1Password secret management
  services.onepassword-secrets = {
    enable = true;
    # Token file should be set up with: sudo opnix token set
    tokenFile = "/etc/opnix-token";

    # Secrets configuration for user passwords
    # NOTE: Store pre-hashed passwords in 1Password using: mkpasswd -m sha-512
    secrets = {
      # User password hash for ungood
      ungoodPassword = {
        reference = "op://Private/ungood-nixos-password/hashed_password";
        owner = "root";
        mode = "0600";
        path = "/run/secrets/ungood-password";
      };

      # User password hash for trafficcone
      trafficconePassword = {
        reference = "op://Private/trafficcone-nixos-password/hashed_password";
        owner = "root";
        mode = "0600";
        path = "/run/secrets/trafficcone-password";
      };
    };
  };
}
