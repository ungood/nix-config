# Disko configuration for sparrowhawk
# Based on simple-efi example with swap partition for hibernation
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };
            # TODO: I didn't partition this host with a swap partition, so this is
            # commented out for now.
            # swap = {
            #   size = "32G";
            #   content = {
            #     type = "swap";
            #     randomEncryption = true;
            #     resumeDevice = true;
            #   };
            # };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
