# Comprehensive printing support with CUPS, network discovery, and driver packages
{
  pkgs,
  ...
}:
{
  # Enable printing services with comprehensive configuration
  services = {
    # CUPS printing service
    printing = {
      enable = true;

      # Enable network printing and browsing
      browsing = true;
      defaultShared = true;

      # PDF virtual printer support
      cups-pdf.enable = true;

      # Comprehensive printer driver packages
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];

      # This bit of magic adds IPP Everywhere printers to the queue automagically.
      # See: https://discourse.nixos.org/t/printers-they-work/17545
      browsedConf = ''
        BrowseDNSSDSubTypes _cups,_print
        BrowseLocalProtocols all
        BrowseRemoteProtocols all
        CreateIPPPrinterQueues All

        BrowseProtocols all
      '';

      # Enable CUPS browsing daemon for network printer discovery
      browsed.enable = true;
    };

    # Enable Avahi for automatic printer discovery via mDNS/DNS-SD
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };
  };

  # Ensure proper permissions for printer management
  users.groups.lp = { };
}
