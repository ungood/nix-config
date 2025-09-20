{
  inputs,
  pkgs,
  lib,
  system ? "x86_64-linux",
}:
let
  # Import test helper functions
  testLib = import ./lib { inherit lib pkgs inputs; };

  # Auto-discover test files
  hostTests = testLib.discoverTests ./hosts;
  moduleTests = testLib.discoverTests ./modules;
  commonTests = testLib.discoverTests ./common;

  # Combine all discovered tests
  allTests = hostTests // moduleTests // commonTests;
in
allTests
