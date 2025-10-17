{
  lib,
  pkgs,
  inputs,
  self,
}:

# Comprehensive test for logos host
# Tests all logos modules: base, desktop.plasma, development
let
  # Load all module test scripts from their new locations adjacent to modules
  moduleTestScripts = [
    (builtins.readFile ../modules/nixos/base/default_test.py)
    (builtins.readFile ../modules/nixos/base/auth_test.py)
    (builtins.readFile ../modules/nixos/desktop/plasma_test.py)
    (builtins.readFile ../modules/nixos/desktop/printing_test.py)
    (builtins.readFile ../modules/nixos/desktop/flatpak_test.py)
    (builtins.readFile ../modules/nixos/development/default_test.py)
    (builtins.readFile ../modules/home/developer/direnv_test.py)
    (builtins.readFile ../modules/home/base/_1password_test.py)
  ];

  combinedTestScript = ''
    #!/usr/bin/env python3
    print("🚀 Starting test for logos host")

    # Start the machine once for all tests
    machine.start()
    machine.wait_for_unit("default.target")

    # Check system status
    machine.execute("systemctl is-system-running --wait")

    ${builtins.concatStringsSep "\n\n" moduleTestScripts}

    print("🎉 All tests completed for logos host!")
  '';
in
pkgs.testers.runNixOSTest {
  name = "logos";

  hostPkgs = lib.mkForce pkgs;
  node.specialArgs = lib.mkForce {
    inherit inputs self pkgs;
  };
  nodes.machine = {
    imports = self.nixosConfigurations.logos._module.args.modules;

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
