# Provides the onetrue.dotfiles.repoPath option, which is the absolute filesystem
# path to the nix-config repository checkout. Modules use this to construct
# mkOutOfStoreSymlink targets for tool-managed config files.
{ lib, ... }:
{
  options.onetrue.dotfiles.repoPath = lib.mkOption {
    type = lib.types.str;
    description = "Absolute filesystem path to the nix-config repository checkout.";
  };
}
