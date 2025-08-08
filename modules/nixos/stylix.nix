{ pkgs, ... }:
{
  stylix = {
    enable = true;
    # This scheme is the default for the system, and can be overriden in home manager per user.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-pale.yaml";
  };
}
