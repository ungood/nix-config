{
  lib,
  pkgs,
  flake,
}:

# Comprehensive test for sparrowhawk host
# Tests all sparrowhawk modules: base, desktop.plasma, development, gaming
let
  inherit (flake) inputs;

  # Load all module test scripts from their new locations adjacent to modules
  moduleTestScripts = [
    (builtins.readFile ../modules/nixos/base/default_test.py)
    (builtins.readFile ../modules/nixos/base/auth_test.py)
    (builtins.readFile ../modules/nixos/desktop/plasma_test.py)
    (builtins.readFile ../modules/nixos/desktop/printing_test.py)
    (builtins.readFile ../modules/nixos/desktop/flatpak_test.py)
    (builtins.readFile ../modules/nixos/development/default_test.py)
    (builtins.readFile ../modules/nixos/gaming/default_test.py)
    (builtins.readFile ../modules/home/developer/direnv_test.py)
    (builtins.readFile ../modules/home/base/_1password_test.py)
  ];

  combinedTestScript = ''
    #!/usr/bin/env python3
    print("🚀 Starting test for sparrowhawk host")

    # Start the machine once for all tests
    machine.start()
    machine.wait_for_unit("default.target")

    # Check system status
    machine.execute("systemctl is-system-running --wait")

    ${builtins.concatStringsSep "\n\n" moduleTestScripts}

    print("🎉 All tests completed for sparrowhawk host!")
  '';
in
pkgs.testers.runNixOSTest {
  name = "sparrowhawk";

  hostPkgs = lib.mkForce pkgs;
  node.specialArgs = lib.mkForce {
    inherit pkgs flake;
  };
  nodes.machine = {

    imports = [
      flake.self.nixosModules.base
      flake.self.nixosModules.desktop
      flake.self.nixosModules.development
      inputs.home-manager.nixosModules.home-manager
    ];

    onetrue.desktop.windowManager = "plasma";

    # VM configuration for testing
    virtualisation = {
      memorySize = 4096;
      diskSize = 16384;
      cores = 4;
      graphics = true;
    };

    # Override for testing
    services.displayManager.autoLogin = {
      enable = true;
      user = "ungood";
    };

    # Add test user with password from secrets flake
    users.users.test = {
      isNormalUser = true;
      hashedPassword = inputs.secrets.passwords.test;
      extraGroups = [ "wheel" ];
    };
  };

  testScript = combinedTestScript;
}
