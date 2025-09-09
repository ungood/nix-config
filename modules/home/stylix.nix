{
  stylix = {
    enable = true;
    targets = {
      firefox = {
        enable = true;
        profileNames = [ "default" ];
        # Default
        firefoxGnomeTheme.enable = false;
      };
      qt = {
        platform = "qtct";
      };
    };
  };
}
