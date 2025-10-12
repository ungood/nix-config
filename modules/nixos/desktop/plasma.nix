{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
  ];

  environment.systemPackages = [
    # Enables the SDDM configuration panel in KDE Config Manager (kcm).
    # Workaround for kcmutils fish-completions issue
    (pkgs.kdePackages.sddm-kcm.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        # Remove broken fish completions reference if it exists
        rm -rf $out/share/fish/vendor_completions.d 2>/dev/null || true
      '';
    }))
  ];

  # Enable the KDE Plasma Desktop Environment.
  services = {
    displayManager.sddm = {
      enable = true;
      # This does not actually work yet
      # See: https://github.com/sddm/sddm/issues/1830
      autoNumlock = true;
    };

    desktopManager.plasma6.enable = true;
  };
}
