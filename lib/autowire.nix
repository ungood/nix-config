{ lib }:
let
  # Helper function: mapAttrs' but filter out null values
  mapAttrsMaybe =
    f: attrs:
    let
      mapped = lib.mapAttrs' f attrs;
    in
    lib.filterAttrs (_: v: v != null) mapped;
in
{
  inherit mapAttrsMaybe;

  # Scan a directory for .nix files and directories with default.nix
  # Returns an attrset where keys are the file/dir names and values are the result of applying f to the path
  forAllNixFiles =
    dir: f:
    if builtins.pathExists dir then
      lib.pipe dir [
        builtins.readDir
        (mapAttrsMaybe (
          fn: type:
          if type == "regular" then
            let
              name = lib.removeSuffix ".nix" fn;
            in
            if name != fn then lib.nameValuePair name (f "${dir}/${fn}") else null
          else if type == "directory" && builtins.pathExists "${dir}/${fn}/default.nix" then
            lib.nameValuePair fn (f "${dir}/${fn}")
          else
            null
        ))
      ]
    else
      { };
}
