{pkgs,...}:
{
  imports = [
    ./wayland.nix
  ];

  # TODO: Use a different terminal?  
  environment.systemPackages = with pkgs; [ kitty ];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.package = pkgs.kdePackages.sddm;
  services.displayManager.sddm.wayland.enable = true;
   
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
}