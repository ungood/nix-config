{
  inputs ? null,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.optionals (inputs != null) [ inputs.agenix.nixosModules.default ];

  # Configure secrets (only if agenix is available)
  age.secrets = lib.mkIf (inputs != null) {
    "ungood-password" = {
      file = ../../../secrets/ungood-password.age;
      owner = "root";
      group = "root";
      mode = "0600";
    };

    "trafficcone-password" = {
      file = ../../../secrets/trafficcone-password.age;
      owner = "root";
      group = "root";
      mode = "0600";
    };
  };

  # Ensure agenix binary is available (only if inputs is available)
  environment.systemPackages = lib.optionals (inputs != null) [
    inputs.agenix.packages.${pkgs.system}.default
  ];

  # Configure SSH keys for secret decryption
  # These should be managed by 1Password SSH agent
  age.identityPaths = lib.mkIf (inputs != null) [
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_ed25519_key"
  ];
}
