{
  imports = [
    ./bluetooth.nix
    ./firefox.nix
    ./1password.nix
    ./printing.nix
  ];

  # Environment variables for proper scaling on Wayland with HiDPI displays
  environment.sessionVariables = {
    # Qt applications (like LightBurn) - enable automatic DPI scaling
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";

    # Electron applications (like VS Code) - use Wayland for proper per-monitor scaling
    ELECTRON_OZONE_PLATFORM_HINT = "auto";

    # Ensure Qt uses Wayland
    QT_QPA_PLATFORM = "wayland";
  };

  services = {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    xserver.enable = false;

    # Enable sound with pipewire.
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance.
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
