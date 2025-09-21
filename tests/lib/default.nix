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
          value = import (testsDir + "/${f}") {
            inherit
              lib
              pkgs
              inputs
              mkNixOSTest
              mkHostTest
              mkModuleTest
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
in
{
  inherit
    mkNixOSTest
    mkHostTest
    mkModuleTest
    mkSmokeTest
    discoverTests
    ;
}
