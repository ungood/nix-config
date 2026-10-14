# Paseo: self-hosted daemon for coding agents.
#
# Runs the daemon as a systemd user service on 127.0.0.1:6767 so other
# machines can add this one as a host over SSH (Settings > Add host > Remote
# SSH in the desktop app), which tunnels to the loopback port and needs no
# daemon password. State and config.json live in ~/.paseo, owned by the daemon.
#
# The service survives logout only if the user lingers (users.users.<name>.linger).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.onetrue.paseo.daemon;
in
{
  options.onetrue.paseo.daemon = {
    enable = lib.mkEnableOption "the Paseo daemon as a systemd user service";

    package = lib.mkPackageOption pkgs "paseo" { };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isLinux;
        message = "onetrue.paseo.daemon uses systemd and is Linux-only.";
      }
    ];

    # The CLI, for `paseo reload`, `paseo daemon set-password`, etc.
    home.packages = [ cfg.package ];

    systemd.user.services.paseo = {
      Unit = {
        Description = "Paseo daemon";
        After = [ "network-online.target" ];
      };

      Service = {
        ExecStart = lib.getExe' cfg.package "paseo-server";
        Restart = "on-failure";
        RestartSec = 5;
        # Agents are started directly by the daemon, not through a shell, so
        # they only see this environment rather than the session variables.
        Environment = [
          "PATH=${config.home.profileDirectory}/bin:/run/wrappers/bin:/run/current-system/sw/bin"
          "PASEO_LISTEN=127.0.0.1:6767"
        ]
        ++ lib.optional (
          config.home.sessionVariables ? CLAUDE_CONFIG_DIR
        ) "CLAUDE_CONFIG_DIR=${config.home.sessionVariables.CLAUDE_CONFIG_DIR}";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
