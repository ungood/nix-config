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
        ../installer
        inputs.disko.nixosModules.disko
      ];

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

    # Check that the installer script is available
    installer.succeed("which install-nixos")
    installer.succeed("test -x $(which install-nixos)")

    # Check that the flake configuration is available
    installer.succeed("test -d /etc/nixos-config")
    installer.succeed("test -f /etc/nixos-config/flake.nix")

    # Check that host configurations are available
    installer.succeed("test -d /etc/nixos-config/hosts/x86_64-linux/sparrowhawk")
    installer.succeed("test -f /etc/nixos-config/hosts/x86_64-linux/sparrowhawk/disko.nix")
    installer.succeed("test -d /etc/nixos-config/hosts/x86_64-linux/logos")
    installer.succeed("test -f /etc/nixos-config/hosts/x86_64-linux/logos/disko.nix")

    # Check that gum is available
    installer.succeed("which gum")

    # Check that disko is available in the installer script
    installer.succeed("grep -q 'disko-install' $(which install-nixos)")

    # Verify SSH is available for remote installation
    installer.succeed("systemctl is-active sshd")

    print("Installer ISO test completed successfully")
  '';
}
