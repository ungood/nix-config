{ lib, ... }:
{
  imports = [
    ./colmena.nix
    ./ssh-keys.nix
  ];

  options.onetrue.deployment = {
    enable = lib.mkEnableOption "deployment capabilities";
    role = lib.mkOption {
      type = lib.types.enum [
        "manager"
        "node"
      ];
      default = "node";
      description = "Deployment role for this host";
    };
    managedBy = lib.mkOption {
      type = lib.types.str;
      default = "sparrowhawk";
      description = "Host that manages deployment for this node";
    };
  };
}
