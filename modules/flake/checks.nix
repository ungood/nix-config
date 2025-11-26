{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      # Recursively find all *_test.py files in modules/nixos directory only
      findTestScripts =
        dir:
        let
          entries = builtins.readDir dir;
          processEntry =
            name: type:
            let
              path = dir + "/${name}";
            in
            if type == "directory" then
              findTestScripts path
            else if type == "regular" && lib.hasSuffix "_test.py" name then
              [ path ]
            else
              [ ];
        in
        lib.flatten (lib.mapAttrsToList processEntry entries);

      # Only test NixOS modules, not home modules
      testScripts = findTestScripts ../../modules/nixos;

      # Load all test scripts
      moduleTestScripts = map builtins.readFile testScripts;

      combinedTestScript = ''
        #!/usr/bin/env python3
        print("🚀 Starting comprehensive NixOS module tests")

        # Start the machine once for all tests
        machine.start()
        machine.wait_for_unit("default.target")

        # Check system status
        machine.execute("systemctl is-system-running --wait")

        ${builtins.concatStringsSep "\n\n" moduleTestScripts}

        print("🎉 All module tests completed successfully!")
      '';
    in
    {
      checks = {
        nixos-modules = pkgs.testers.runNixOSTest {
          name = "nixos-modules";

          hostPkgs = lib.mkForce pkgs;
          node.specialArgs = lib.mkForce {
            flake = {
              inherit inputs;
              inherit (inputs) self;
            };
            inherit pkgs;
          };

          nodes.machine =
            { modulesPath, ... }:
            {
              imports = [
                (modulesPath + "/misc/nixpkgs/read-only.nix")
                inputs.self.nixosModules.base
                inputs.self.nixosModules.desktop
                inputs.self.nixosModules.development
                inputs.self.nixosModules.gaming
                inputs.home-manager.nixosModules.home-manager
              ];

              # Use our pre-configured pkgs with overlays and unfree enabled
              nixpkgs.pkgs = pkgs;

              # Configure home-manager
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-backup";

                extraSpecialArgs = {
                  flake = {
                    inherit inputs;
                    inherit (inputs) self;
                  };
                };
              };

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
        };
      };
    };
}
