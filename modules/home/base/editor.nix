{ pkgs, ... }:
{
  home.packages = [
    pkgs.nano
    (pkgs.writeShellScriptBin "edit" ''
      # Mimic Debian's editor behavior:
      # 1. Use $VISUAL if set
      # 2. Fall back to $EDITOR if set
      # 3. Fall back to nano as system default

      if [ -n "$VISUAL" ]; then
        exec "$VISUAL" "$@"
      elif [ -n "$EDITOR" ]; then
        exec "$EDITOR" "$@"
      else
        exec ${pkgs.nano}/bin/nano "$@"
      fi
    '')
  ];
}
