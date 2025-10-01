# Test for the NixOS installer ISO
# This test does not work yet because the installer expects an internet
# connection and I gave up on figuring out how to package ALL dependencies
# correctly.
{
  inputs,
  pkgs,
  lib,
  self,
  ...
}:
pkgs.testers.runNixOSTest {
  name = "installer";

  node = {
    specialArgs = lib.mkForce {
      inherit inputs self pkgs;
    };
  };

  nodes = {

    machine = {
      imports = self.nixosConfigurations.installer._module.args.modules;

      virtualisation = {
        memorySize = 8192;
        diskSize = 8192;
        # Add an additional disk for installation target
        emptyDiskImages = [ 4096 ];
        cores = 4;
      };
    };
  };

  # Test script based on https://github.com/nix-community/disko/blob/master/tests/disko-install/default.nix
  # TODO: Test that the installed machine starts.
  testScript = ''
    start_all()

    # Wait for the system to boot
    machine.wait_for_unit("multi-user.target")

    machine.succeed("install-nixos logos /dev/vdb")

    print("Installation completed successfully!")

    # Verify the installation created partitions
    machine.succeed("lsblk /dev/vdb | grep -E 'vdb[0-9]'")

    # Check if filesystems were created
    machine.succeed("blkid /dev/vdb1 | grep -E '(vfat|FAT)'")  # ESP partition
    machine.succeed("blkid /dev/vdb2 || blkid /dev/vdb3")  # Root partition (could be vdb2 or vdb3 depending on swap)

    print("Installer test completed successfully - install-nixos ran to completion!")
  '';
}
