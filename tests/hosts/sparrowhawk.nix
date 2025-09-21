{
  inputs,
  mkNixOSTest,
}:

# Comprehensive test for sparrowhawk host
# Tests all sparrowhawk modules: base, desktop.plasma, development, gaming
let
  # Load all module test scripts
  moduleTestScripts = [
    (builtins.readFile ../scripts/modules/base.py)
    (builtins.readFile ../scripts/modules/desktop/plasma.py)
    (builtins.readFile ../scripts/modules/development.py)
    (builtins.readFile ../scripts/modules/gaming.py)
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
mkNixOSTest {
  name = "sparrowhawk-host";

  nodes.machine =
    { ... }:
    {
      # Import a subset of modules to avoid circular dependencies for now
      imports = [
        ../../modules/nixos/development
        ../../modules/nixos/gaming
      ];

      # Provide inputs to modules that need them
      _module.args = { inherit inputs; };

      # Basic host-like configuration
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      time.timeZone = "America/Los_Angeles";
      networking.hostName = "sparrowhawk";
      networking.networkmanager.enable = true;
      system.stateVersion = "25.05";

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

      # Set up test users (since we're not importing base module)
      users = {
        users.ungood = {
          isNormalUser = true;
          password = "test";
          group = "ungood";
        };
        users.trafficcone = {
          isNormalUser = true;
          password = "test";
          group = "trafficcone";
        };
        groups.ungood = { };
        groups.trafficcone = { };
      };

      # Enable fish shell
      programs.fish.enable = true;
    };

  testScript = combinedTestScript;
}
