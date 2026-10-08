_:
{ pkgs, lib, ... }:
{
  fonts = {
    # Install other fonts I use.
    packages = with pkgs; [
      corefonts
      vista-fonts
      nerd-fonts.inconsolata
      nerd-fonts.dejavu-sans-mono
    ];
  }
  // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    # Install some default fonts
    enableDefaultPackages = true;
  };
}
