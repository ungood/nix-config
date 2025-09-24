{
  lib,
  pkgs,
  inputs,
  self,
}:

# Comprehensive test for sparrowhawk host
# Tests all sparrowhawk modules: base, desktop.plasma, development, gaming
let
  # Load all module test scripts
  moduleTestScripts = [
    (builtins.readFile ./scripts/modules/base.py)
    (builtins.readFile ./scripts/modules/desktop/plasma.py)
    (builtins.readFile ./scripts/modules/development.py)
    (builtins.readFile ./scripts/modules/gaming.py)
  ];

  combinedTestScript = ''
    #!/usr/bin/env python3
    """
    Comprehensive test for sparrowhawk host.
    Tests all modules: base, desktop.plasma, development, gaming
    """

    print("🚀 Starting comprehensive test for sparrowhawk host")
    print("📋 Testing modules: base, desktop.plasma, development, gaming")

    # Start the machine once for all tests
    machine.start()
    machine.wait_for_unit("default.target")
    machine.succeed("systemctl is-system-running --wait")

    print("✅ Host sparrowhawk is ready for testing")

    ${builtins.concatStringsSep "\n\n" moduleTestScripts}

    print("🎉 All tests completed for sparrowhawk host!")
  '';
in
pkgs.testers.runNixOSTest {
  name = "sparrowhawk";

  hostPkgs = lib.mkForce pkgs;
  node = {
    pkgs = lib.mkForce pkgs;
    specialArgs = lib.mkForce {
      inherit inputs self pkgs;
    };
  };
  nodes.machine = {
    imports = self.nixosConfigurations.sparrowhawk._module.args.modules;
    #self.nixosModules;
    #../hosts/x86_64-linux/sparrowhawk/default.nix
    #];

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
  };

  testScript = combinedTestScript;
}
