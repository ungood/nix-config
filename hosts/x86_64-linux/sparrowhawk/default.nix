{
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.base
    inputs.self.nixosModules.desktop.plasma
    inputs.self.nixosModules.development
    inputs.self.nixosModules.gaming
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "sparrowhawk";
    networkmanager.enable = true;
  };

  # Enable OneTrue authentication system
  onetrue.auth = {
    enable = true;

    # Enable fingerprint authentication if hardware supports it
    fingerprintAuth.enable = true;

    # Enable SSH key-based sudo authorization
    sshKeySudo = {
      enable = true;
      authorizedKeys = {
        ungood = [
          # Add SSH public key for ungood user sudo access
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5YgjKUQ6huYMTTdJ+jW2Bqa4S4YnNEwV6wQQ3T8j8zT+1xjFYbK7W2mZ3zE1+7eQ4fB9rQoQmVq2Y9jJU8w2Qr4MqK5YgjKUQ6huYMTTdJ+jW2Bqa4S4YnNEwV6wQQ3T8j8zT+1xjFYbK7W2mZ3zE1+7eQ4fB9rQoQmVq2Y9jJU8w2Qr4MqK"
        ];
      };
    };

    # Enable root password fallback for sudo
    rootPasswordFallback.enable = true;
  };

  system.stateVersion = "25.05";
}
