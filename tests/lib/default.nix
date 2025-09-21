{
  lib,
  pkgs,
  inputs,
}:
let
  # Helper function to create a basic NixOS test
  mkNixOSTest = args: pkgs.testers.runNixOSTest args;

  # Helper function to create tests for a specific host configuration
  mkHostTest = hostName: hostConfig: {
    name = "host-${hostName}";
    nodes.machine = lib.recursiveUpdate {
      # Default VM configuration for testing
      virtualisation = {
        memorySize = 2048;
        diskSize = 8192;
        cores = 2;
        graphics = false;
      };
    } hostConfig;
    testScript = ''
      # Basic host validation
      machine.start()
      machine.wait_for_unit("default.target")
      machine.succeed("systemctl is-system-running --wait")

      # Verify host-specific configuration
      machine.succeed("hostname | grep ${hostName}")
    '';
  };

  # Helper function to create tests for a specific module
  mkModuleTest = moduleName: moduleConfig: {
    name = "module-${moduleName}";
    nodes.machine =
      { ... }:
      {
        imports = [ moduleConfig ];

        # VM configuration for testing
        virtualisation = {
          memorySize = 2048;
          diskSize = 8192;
          cores = 2;
          graphics = false;
        };

        # Minimal system configuration for testing
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        fileSystems."/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };
      };
    testScript = ''
      machine.start()
      machine.wait_for_unit("default.target")
      machine.succeed("systemctl is-system-running --wait")
    '';
  };

  # Auto-discovery function for test files
  discoverTests =
    testsDir:
    let
      # Check if directory exists
      exists = builtins.pathExists testsDir;
    in
    if !exists then
      { }
    else
      let
        # Read directory contents
        files = lib.attrNames (builtins.readDir testsDir);

        # Filter for .nix files (excluding default.nix)
        nixFiles = lib.filter (f: lib.hasSuffix ".nix" f && f != "default.nix") files;

        # Import each test file - these should already be test derivations
        tests = map (f: {
          name = lib.removeSuffix ".nix" f;
          value =
            # Determine what arguments to pass based on the directory
            if testsDir == ../hosts then
              # Host tests need these functions
              import (testsDir + "/${f}") {
                inherit
                  lib
                  pkgs
                  inputs
                  mkNixOSTest
                  ;
              }
            else
              # Other tests get the full set of functions
              import (testsDir + "/${f}") {
                inherit
                  lib
                  pkgs
                  inputs
                  mkNixOSTest
                  mkHostTest
                  mkModuleTest
                  mkHostTestWithModules
                  mkModuleTestWithScript
                  loadPythonScript
                  discoverHostModules
                  loadModuleTestScripts
                  ;
              };
        }) nixFiles;
      in
      lib.listToAttrs tests;

  # Function to create a basic smoke test
  mkSmokeTest =
    name: config:
    mkNixOSTest {
      inherit name;
      nodes.machine = lib.recursiveUpdate {
        # Default VM configuration for testing
        virtualisation = {
          memorySize = 2048;
          diskSize = 8192;
          cores = 2;
          graphics = false;
        };
      } config;
      testScript = ''
        machine.start()
        machine.wait_for_unit("default.target")
        machine.succeed("systemctl is-system-running --wait")
        machine.succeed("echo 'Smoke test passed for ${name}'")
      '';
    };

  # Function to discover modules imported by a host configuration
  discoverHostModules =
    hostName:
    # For now, we'll hardcode the known modules per host
    # In the future, this could parse the actual host configuration
    if hostName == "sparrowhawk" then
      [
        "base"
        "desktop.plasma"
        "development"
        "gaming"
      ]
    else
      [ "base" ]; # Default to just base module for unknown hosts

  # Function to load and combine module test scripts
  loadModuleTestScripts =
    modules:
    let
      scriptContents = map (
        moduleName:
        let
          # Convert module name to script path (e.g., "desktop.plasma" -> "desktop/plasma.py")
          scriptPath = ../scripts/modules + "/${lib.replaceStrings [ "." ] [ "/" ] moduleName}.py";
        in
        if builtins.pathExists scriptPath then
          "# === ${moduleName} Module Tests ===\n" + builtins.readFile scriptPath + "\n"
        else
          "print(\"⚠️  No test script found for module: ${moduleName}\")\n"
      ) modules;
    in
    builtins.concatStringsSep "\n" scriptContents;

  # Function to create a comprehensive host test with all module tests
  mkHostTestWithModules =
    hostName: hostConfig:
    let
      modules = discoverHostModules hostName;
      combinedTestScript = loadModuleTestScripts modules;

      # Add host-specific test wrapper
      hostTestScript = ''
        #!/usr/bin/env python3
        """
        Comprehensive test for ${hostName} host.
        Tests all modules: ${builtins.concatStringsSep ", " modules}
        """

        print("🚀 Starting comprehensive test for ${hostName} host")
        print("📋 Testing modules: ${builtins.concatStringsSep ", " modules}")

        # Start the machine once for all tests
        machine.start()
        machine.wait_for_unit("default.target")
        machine.succeed("systemctl is-system-running --wait")

        print("✅ Host ${hostName} is ready for testing")

        ${combinedTestScript}

        print("🎉 All tests completed for ${hostName} host!")
      '';
    in
    mkNixOSTest {
      name = "${hostName}-host";
      nodes.machine =
        { ... }:
        {
          imports = [
            # Import the host config with inputs provided
            (import hostConfig { inherit inputs; })
          ];

          virtualisation = {
            memorySize = 4096; # More memory for full host configs
            diskSize = 16384; # More disk space
            cores = 4;
            graphics = true; # Enable for desktop testing
          };

          # Override some settings for VM testing
          services.xserver.displayManager.autoLogin = {
            enable = true;
            user = "ungood";
          };

          # Ensure passwords work in test environment
          users.users.ungood.password = "test";
          users.users.trafficcone.password = "test";
        };

      testScript = hostTestScript;
    };

  # Function to load Python test script from file
  loadPythonScript =
    scriptPath:
    if builtins.pathExists scriptPath then
      builtins.readFile scriptPath
    else
      ''
        # Default test script
        machine.start()
        machine.wait_for_unit("default.target")
        machine.succeed("systemctl is-system-running --wait")
        print("✅ Basic test completed")
      '';

  # Function to create module-specific test with Python script
  mkModuleTestWithScript =
    moduleName: moduleConfig:
    let
      scriptPath = ../scripts/modules + "/${moduleName}.py";
      pythonScript = loadPythonScript scriptPath;
    in
    mkNixOSTest {
      name = "module-${moduleName}";
      nodes.machine = {
        imports = [ moduleConfig ];

        virtualisation = {
          memorySize = 2048;
          diskSize = 8192;
          cores = 2;
          graphics = false;
        };

        # Minimal boot configuration
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        fileSystems."/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };
      };

      testScript = pythonScript;
    };
in
{
  inherit
    mkNixOSTest
    mkHostTest
    mkModuleTest
    mkSmokeTest
    mkHostTestWithModules
    mkModuleTestWithScript
    loadPythonScript
    discoverHostModules
    loadModuleTestScripts
    discoverTests
    ;
}
