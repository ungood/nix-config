{ pkgs, ... }:
{
  # Home-manager configuration
  home = {
    username = "ungood";
    stateVersion = "25.05";
  };

  # NixOS system user configuration
  nixos = {
    isNormalUser = true;
    description = "Jason";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    # Password will be set from secrets flake if available, otherwise use fallback
    hashedPassword = "$6$rjeVEWs48nDDNVBT$Jk95HAHTdimzeGOaHYwEr2C/84oHhsssWbdX0q8uQpEr5H8YdPZuh/zPOdgJ3ddI5pk.9j4/y4cmGYuHkTQFO1";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5YgjKUQ6huYMTTdJ+jW2Bqa4S4YnNEwV6wQQ3T8j8zT+1xjFYbK7W2mZ3zE1+7eQ4fB9rQoQmVq2Y9jJU8w2Qr4MqK5YgjKUQ6huYMTTdJ+jW2Bqa4S4YnNEwV6wQQ3T8j8zT+1xjFYbK7W2mZ3zE1+7eQ4fB9rQoQmVq2Y9jJU8w2Qr4MqK ungood@sparrowhawk"
    ];
  };
}
