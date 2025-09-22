{
  mkNixOSTest,
}:

# Test for authentication modules: auth and sudo
mkNixOSTest {
  name = "auth-modules";

  nodes.machine =
    { ... }:
    {
      # Import the authentication modules
      imports = [
        ../../modules/nixos/base/auth.nix
        ../../modules/nixos/base/sudo.nix
      ];

      # Basic host configuration
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      time.timeZone = "America/Los_Angeles";
      networking.hostName = "auth-test";
      system.stateVersion = "25.05";

      # VM configuration for testing
      virtualisation = {
        memorySize = 2048;
        diskSize = 8192;
        cores = 2;
      };

      # Set up test users
      users = {
        mutableUsers = false;
        users.testuser = {
          isNormalUser = true;
          hashedPassword = "$6$test$test.password.hash";
          extraGroups = [ "wheel" ];
        };
      };

    };

  testScript = ''
    #!/usr/bin/env python3
    """
    Test authentication modules: auth and sudo
    """

    print("🚀 Starting authentication modules test")

    # Start the machine
    machine.start()
    machine.wait_for_unit("default.target")
    machine.succeed("systemctl is-system-running --wait")

    print("✅ Machine is ready for testing")


    # Test sudo configuration
    print("🔍 Testing sudo configuration...")
    machine.succeed("test -f /etc/sudoers")
    machine.succeed("visudo -c")
    print("✅ sudo configuration is valid")

    # Test PAM configuration files exist
    print("🔍 Testing PAM configuration...")
    machine.succeed("test -f /etc/pam.d/sudo")
    machine.succeed("test -f /etc/pam.d/login")
    print("✅ PAM configuration files exist")

    # Test SSH agent authentication module
    print("🔍 Testing SSH agent auth module...")
    machine.succeed("ls /nix/store/ | grep pam_ssh_agent_auth")
    machine.succeed("find /nix/store -name 'pam_ssh_agent_auth.so' | head -1")
    print("✅ SSH agent authentication module is available")

    # Test wheel group exists and has proper sudo access
    print("🔍 Testing wheel group configuration...")
    machine.succeed("getent group wheel")
    print("✅ wheel group exists")

    print("🎉 Authentication modules test completed!")
  '';
}
