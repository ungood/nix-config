# Test for the NixOS installer ISO components
{
  inputs,
  pkgs,
  lib,
  self,
  ...
}:
pkgs.nixosTest {
  name = "installer-test";

  nodes = {
    installer = { pkgs, ... }: {
      # Test that installation script works (without the full ISO)
      environment.systemPackages = with pkgs; [
        git
        vim
        parted
        gptfdisk
        cryptsetup
      ];

      # Simulate the installer environment
      environment.etc = {
        "nixos-installer/install.sh" = {
          source = ../installer/install-script.sh;
          mode = "0755";
        };
        "nixos-installer/hosts/sparrowhawk/disko.nix".source = ../hosts/x86_64-linux/sparrowhawk/disko.nix;
        "nixos-installer/hosts/logos/disko.nix".source = ../hosts/x86_64-linux/logos/disko.nix;
      };

      virtualisation = {
        memorySize = 2048;
        diskSize = 10240;
        # Add an additional disk for installation target
        emptyDiskImages = [ 5120 ];
      };
    };
  };

  testScript = ''
    start_all()

    # Wait for the system to boot
    installer.wait_for_unit("multi-user.target")

    # Check that the install script is available
    installer.succeed("test -f /etc/nixos-installer/install.sh")
    installer.succeed("test -x /etc/nixos-installer/install.sh")

    # Check that host disko configurations are available
    installer.succeed("test -f /etc/nixos-installer/hosts/sparrowhawk/disko.nix")
    installer.succeed("test -f /etc/nixos-installer/hosts/logos/disko.nix")

    # Test the installation script's help/listing functionality
    # We can't test the full installation in this environment, but we can verify the script runs
    output = installer.succeed("echo '3' | /etc/nixos-installer/install.sh || true")
    assert "Invalid selection" in output, "Install script should reject invalid selection"

    # Test that we can list available configurations
    output = installer.succeed("echo | timeout 5 /etc/nixos-installer/install.sh || true")
    assert "sparrowhawk" in output, "Should list sparrowhawk configuration"
    assert "logos" in output, "Should list logos configuration"

    print("Installer test completed successfully")
  '';
}