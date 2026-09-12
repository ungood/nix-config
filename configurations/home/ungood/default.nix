flake@{ self, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Import developer modules
  imports = [
    self.homeModules.base
    self.homeModules.developer
    (import ./bat.nix flake)
    (import ./claude flake)
    (import ./ghostty.nix flake)
    (import ./git.nix flake)
    (import ./vscode flake)
  ];

  # Home-manager configuration
  home = {
    username = "ungood";
    stateVersion = "25.05";

    packages =
      with pkgs;
      [
        gum
        # Obsidian with HM is a PITA to use with community packages right now so I currently just install the package
        # See: https://github.com/nix-community/home-manager/pull/6487#issuecomment-2667166722
        obsidian
        todoist
      ]
      ++ lib.optionals stdenv.isDarwin [
        rectangle
      ]
      ++ lib.optionals stdenv.isLinux [
        beeper
      ];

    sessionVariables = {
      GREP_OPTIONS = "--color=auto";
      LESS = "-iMFXR";
      # NONE is gcloud's reserved read-only configuration: it holds no
      # properties and refuses writes, so there is no ambient account and
      # nothing can accidentally populate it. Directories that need an
      # account set this to a real configuration via direnv.
      CLOUDSDK_ACTIVE_CONFIG_NAME = "NONE";
    };
  };

  # Block ambient Application Default Credentials. `gcloud auth
  # application-default login` writes this path with a plain open(), so a
  # read-only /nix/store symlink makes the write fail instead of silently
  # creating a machine-wide default credential. Projects that genuinely need
  # ADC should point CLOUDSDK_CONFIG at a writable per-project directory.
  home.file.".config/gcloud/application_default_credentials.json".text = builtins.toJSON {
    _comment = "Intentionally not a credential. Managed read-only by home-manager to prevent ambient ADC.";
  };

  # TODO: Move this somewhere more appropriate.
  targets.darwin = {
    linkApps.enable = false;
    copyApps.enable = pkgs.stdenv.isDarwin;
  };

  programs = {
    fish = {
      enable = true;
      plugins = with pkgs.fishPlugins; [
        {
          name = "${config.home.username}";
          # TODO, it would be nice if this was somehow a symlink so changes could be realized without switching
          # However, I triked mkOutOfLinkSymlink and the way the plugin gets generated doesn't quite work.
          src = ./fish;
        }
        {
          name = "z";
          inherit (z) src;
        }
      ];
    };

    starship = {
      enable = true;
      settings = {
        git_branch.truncation_length = 30;

        # Distinct icons; both default to the same generic cloud.
        aws.symbol = " ";
        gcloud = {
          symbol = " ";
          # Wrapping the default format in ( ) collapses the whole module when
          # $account is empty, so a sentinel CLOUDSDK_ACTIVE_CONFIG_NAME shows
          # nothing at all rather than a bare icon.
          format = "(on [$symbol$account(@$domain)(\\($region\\))]($style) )";
        };
      };
    };
  };

  onetrue = {
    avatar.path = ./metroid.png;
    dotfiles.repoPath = lib.mkDefault "${config.home.homeDirectory}/nix-config";
  };
}
