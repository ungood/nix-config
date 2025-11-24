{ inputs, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      # Auto-discover and import all tests from tests directory
      discoverTests =
        dir:
        let
          testFiles = builtins.readDir dir;
          testNames = builtins.attrNames (
            lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) testFiles
          );
        in
        lib.listToAttrs (
          map (
            testFile:
            let
              testName = lib.removeSuffix ".nix" testFile;
            in
            {
              name = testName;
              value = import (dir + "/${testFile}") {
                inherit inputs pkgs lib;
              };
            }
          ) testNames
        );
    in
    {
      checks = discoverTests ../../tests;
    };
}
