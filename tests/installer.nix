# Test for the NixOS installer ISO
{
  inputs,
  pkgs,
  ...
}:
pkgs.nixosTest {
  name = "installer-test";

  nodes = {
    installer = {
      imports = [
        ../hosts/x86_64-linux/installer
        inputs.disko.nixosModules.disko
      ];

      virtualisation = {
        memorySize = 4096;
        diskSize = 10240;
        # Add an additional disk for installation target
        emptyDiskImages = [ 8192 ];
      };
    };
  };

  testScript = ''
    start_all()

    # Wait for the system to boot
    installer.wait_for_unit("multi-user.target")

    # Verify all required components are present
    installer.succeed("which install-nixos")
    installer.succeed("which gum")
    installer.succeed("which disko-install")

    # Verify the flake configuration is available
    installer.succeed("test -d /etc/nixos-config")
    installer.succeed("test -f /etc/nixos-config/flake.nix")

    # Verify host configurations are available
    installer.succeed("test -f /etc/nixos-config/hosts/x86_64-linux/sparrowhawk/default.nix")
    installer.succeed("test -f /etc/nixos-config/hosts/x86_64-linux/logos/default.nix")

    # Verify empty disk is available
    installer.succeed("test -b /dev/vdb")
    installer.succeed("lsblk /dev/vdb")

    # Get the disk ID for vdb (required by the installer)
    disk_id_result = installer.execute("ls -la /dev/disk/by-id/ | grep -E 'vdb$' | awk '{print $9}' | head -n1")
    disk_id = disk_id_result[1].strip() if disk_id_result[0] == 0 else ""

    if disk_id:
        print("Found disk ID: " + disk_id)
    else:
        # Create a symlink if by-id doesn't exist (common in VMs)
        print("No disk by-id found, creating symlink for test")
        installer.succeed("mkdir -p /dev/disk/by-id")
        installer.succeed("ln -sf /dev/vdb /dev/disk/by-id/virtio-test-disk-vdb")
        disk_id = "virtio-test-disk-vdb"

    # Run the installer directly with arguments to skip interactive prompts
    # This tests the full installation process without needing expect
    print("Running install-nixos script with direct arguments...")
    installer.succeed("install-nixos logos vdb")

    print("Installation completed successfully!")

    # Verify the installation created partitions
    installer.succeed("lsblk /dev/vdb | grep -E 'vdb[0-9]'")

    # Check if filesystems were created
    installer.succeed("blkid /dev/vdb1 | grep -E '(vfat|FAT)'")  # ESP partition
    installer.succeed("blkid /dev/vdb2 || blkid /dev/vdb3")  # Root partition (could be vdb2 or vdb3 depending on swap)

    print("Installer test completed successfully - install-nixos ran to completion!")
  '';
}
