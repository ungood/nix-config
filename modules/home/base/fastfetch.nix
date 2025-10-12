{
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        type = "none";
      };

      modules = [
        { type = "title"; }
        { type = "separator"; }
        { type = "uptime"; }
        {
          type = "cpu";
          showPeCoreCount = true;
          temp = true;
        }
        {
          type = "gpu";
          driverSpecific = true;
          temp = true;
        }
        { type = "memory"; }
        {
          type = "swap";
          separate = true;
        }
        { type = "disk"; }
        { type = "localip"; }
      ];
    };
  };
}
