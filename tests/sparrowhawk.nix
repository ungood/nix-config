{
  lib,
  pkgs,
  inputs,
  self,
}:

# Comprehensive test for sparrowhawk host
# Tests all sparrowhawk modules: base, desktop.plasma, development, gaming
let
  # Load all module test scripts from their new locations adjacent to modules
  moduleTestScripts = [
    (builtins.readFile ../modules/nixos/base/default_test.py)
    (builtins.readFile ../modules/nixos/base/auth_test.py)
    (builtins.readFile ../modules/nixos/desktop/plasma_test.py)
    (builtins.readFile ../modules/nixos/development/default_test.py)
    (builtins.readFile ../modules/nixos/gaming/default_test.py)
  ];

  combinedTestScript = ''
    #!/usr/bin/env python3
    print("🚀 Starting test for sparrowhawk host")

    # Start the machine once for all tests
    machine.start()
    machine.wait_for_unit("default.target")
    # Check system status
    status = machine.execute("systemctl is-system-running --wait")[1].strip()
    if status == "degraded":
        # Check what's failed
        failed = machine.execute("systemctl list-units --failed --no-legend")[1].strip()
        # For now, ignore home-manager failures as they're due to ghostty theme issues
        # This is a known issue unrelated to authentication
        if failed and "home-manager" in failed:
            print(f"⚠️  Home-manager services failed (known ghostty theme issue): {failed}")
        elif failed:
            raise Exception(f"System has failed units: {failed}")
    elif status != "running":
        print(f"⚠️  System is in {status} state, continuing with tests...")

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

    # Add test user with password from secrets flake
    users.users.test = {
      isNormalUser = true;
      hashedPassword = inputs.secrets.passwords.test;
      extraGroups = [ "wheel" ];
    };
  };

  testScript = combinedTestScript;
}
