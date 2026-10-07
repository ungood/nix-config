{ inputs, ... }:
{
  perSystem =
    { lib, system, ... }:
    {
      apps = lib.optionalAttrs (lib.hasSuffix "-darwin" system) {
        # Export this Mac's preferences that differ from macOS defaults as
        # nix-plist-manager options. Read-only: it never applies anything.
        # Usage: nix run .#capture-prefs -- [<out.nix>] [--scope user|system] [--against <file.nix>]
        capture-prefs = inputs.nix-plist-manager.apps.${system}.current // {
          meta.description = "Capture macOS preferences as nix-plist-manager Nix options";
        };
      };
    };
}
