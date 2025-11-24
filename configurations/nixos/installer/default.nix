# Custom NixOS installer ISO using disko-install
{
  flake,
  pkgs,
  lib,
  modulesPath,
  ...
}:
let
  inherit (flake) inputs;
  inherit (inputs) self;

  # TODO: Package all hosts here.
  dependencies = [
    self.nixosConfigurations.logos.config.system.build.toplevel
    self.nixosConfigurations.logos.config.system.build.diskoScript
    self.nixosConfigurations.logos.config.system.build.diskoScript.drvPath
    self.nixosConfigurations.logos.pkgs.stdenv.drvPath
    (self.nixosConfigurations.logos.pkgs.closureInfo { rootPaths = [ ]; }).drvPath

    # https://github.com/NixOS/nixpkgs/blob/f2fd33a198a58c4f3d53213f01432e4d88474956/nixos/modules/system/activation/top-level.nix#L342
    self.nixosConfigurations.logos.pkgs.perlPackages.ConfigIniFiles
    self.nixosConfigurations.logos.pkgs.perlPackages.FileSlurp
  ]
  ++ builtins.map (i: i.outPath) (builtins.attrValues inputs);

  closureInfo = pkgs.closureInfo { rootPaths = dependencies; };
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  environment = {
    # Include closure info for offline installation
    etc."install-closure".source = "${closureInfo}/store-paths";

    # Symlink to this flake so it's easy to reference from install-nixos.sh
    etc."nixos-configs".source = "${self}";

    # Available host configurations (update when adding new hosts)
    systemPackages = with pkgs; [
      (writeShellScriptBin "install-nixos" (builtins.readFile ./install-nixos.sh))
      gum
      disko
    ];
  };

  # do not try to fetch stuff from the internet
  nix.settings = {
    # substituters = lib.mkForce [ ];
    # hashed-mirrors = null;
    # connect-timeout = 3;
    # flake-registry = pkgs.writeText "flake-registry" ''{"flakes":[],"version":2}'';
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # reduce closure size
  documentation.doc.enable = false;
  documentation.man.enable = false;

  services.getty.helpLine = "To install NixOS: sudo install-nixos";

  networking.networkmanager.enable = true;

  image.baseName = lib.mkForce "nixos-installer";
  isoImage = {
    volumeID = lib.mkForce "nixos-installer";
    makeEfiBootable = true;
    makeUsbBootable = true;
  };
}
