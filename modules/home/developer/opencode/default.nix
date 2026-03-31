# OpenCode configuration and plugins
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.opencode-web;
in
{
  options.services.opencode-web = {
    enable = lib.mkEnableOption "OpenCode web server";

    package = lib.mkOption {
      type = lib.types.package;
      default = config.programs.opencode.package;
      defaultText = lib.literalExpression "config.programs.opencode.package";
      description = "The OpenCode package to use.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 4096;
      description = "Port to run the OpenCode web server on.";
    };

    workspace = lib.mkOption {
      type = lib.types.str;
      description = "Working directory for the OpenCode web server.";
    };
  };

  config = lib.mkMerge [
    {
      programs = {
        opencode = {
          enable = true;
          settings = {
            plugin = [
              #"@simonwjackson/opencode-direnv" #commented out until PR is merged.
            ];
          };
        };
        fish.shellAbbrs.oc = "opencode";
      };
    }
    (lib.mkIf cfg.enable (
      lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isDarwin {
          launchd.agents.opencode-web = {
            enable = true;
            config = {
              ProgramArguments = [
                (lib.getExe cfg.package)
                "web"
                "--port"
                (toString cfg.port)
              ];
              WorkingDirectory = cfg.workspace;
              RunAtLoad = true;
              KeepAlive = true;
              StandardOutPath = "${config.home.homeDirectory}/Library/Logs/opencode-web.out.log";
              StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/opencode-web.err.log";
            };
          };
        })
        (lib.mkIf pkgs.stdenv.isLinux {
          systemd.user.services.opencode-web = {
            Unit = {
              Description = "OpenCode Web Server";
              After = [ "network.target" ];
            };
            Service = {
              Type = "simple";
              ExecStart = "${lib.getExe cfg.package} web --port ${toString cfg.port}";
              WorkingDirectory = cfg.workspace;
              Restart = "on-failure";
            };
            Install = {
              WantedBy = [ "default.target" ];
            };
          };
        })
      ]
    ))
  ];
}
