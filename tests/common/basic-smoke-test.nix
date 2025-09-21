{
  pkgs,
  mkNixOSTest,
}:

# Basic smoke test to validate the testing infrastructure
mkNixOSTest {
  name = "basic-smoke-test";

  nodes.machine = {
    # VM configuration for testing
    virtualisation = {
      memorySize = 2048; # 2GB minimum as specified
      diskSize = 8192; # 8GB disk space
      cores = 2; # 2 CPU cores for reasonable performance
      graphics = false; # Headless by default
    };

    # Minimal system configuration for testing
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    # Basic system packages for testing
    environment.systemPackages = with pkgs; [
      curl
      wget
      vim
    ];

    # Enable basic services
    services.getty.autologinUser = "root";
  };

  testScript = ''
    # Start the VM and wait for it to boot
    machine.start()

    # Wait for the system to reach default target
    machine.wait_for_unit("default.target")

    # Verify system is running
    machine.succeed("systemctl is-system-running --wait")

    # Test basic package availability
    machine.succeed("curl --version")
    machine.succeed("wget --version")
    machine.succeed("vim --version")

    # Test basic system functionality
    machine.succeed("echo 'Basic smoke test passed' > /tmp/test")
    machine.succeed("cat /tmp/test | grep 'Basic smoke test passed'")

    # Verify we can access the filesystem
    machine.succeed("ls -la /")
    machine.succeed("df -h")

    print("✅ Basic smoke test completed successfully!")
  '';
}
