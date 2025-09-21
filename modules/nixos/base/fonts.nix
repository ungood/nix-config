{ pkgs, ... }:
{
  fonts = {
    # Install some default fonts
    enableDefaultPackages = true;

    # Install other fonts I use.
    packages = with pkgs; [
      corefonts
      vista-fonts
      nerd-fonts.inconsolata
    ];
  };
}
