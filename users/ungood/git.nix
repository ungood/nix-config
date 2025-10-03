{
  programs.git = {
    enable = true;
    userName = "Jason Walker";
    userEmail = "jason@onetrue.name";

    extraConfig = {
      # Do not guess defaults for user.email and user.name
      user.useConfigOnly = true;

      core = {
        editor = "vim";
        pager = "less -FMRiX";
        abbrev = 8;
      };

      color = {
        ui = "auto";
        branch = {
          current = "green ul";
          local = "yellow";
          remote = "red";
          plain = "normal";
        };
        decorate = {
          HEAD = "green ul";
          remoteBranch = "red";
          branch = "yellow";
          tag = "cyan";
          stash = "bold cyan";
        };
      };

      column.ui = "auto";

      format.pretty = "%w(80,0,4)%C(bold red)%h %C(bold blue)%ad %C(green)%an%C(yellow)%d%n%Creset%s";

      apply.whitespace = "nowarn";

      mergetool = {
        keepBackup = false;
        prompt = false;
        keepTemporaries = false;
      };

      log.date = "short";
      merge.tool = "p4merge";

      diff = {
        guitool = "p4merge";
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };

      pull.rebase = true;

      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };

      fetch = {
        parallel = 0;
        prune = true;
        pruneTags = true;
        all = true;
      };

      branch = {
        autosetuprebase = "always";
        sort = "-committerdate";
      };

      rerere.enabled = true;
      init.defaultBranch = "main";

      protocol.codecommit.allow = "always";

      tag.sort = "version:refname";
      help.autocorrect = "prompt";

      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
    };

    # Aliases
    aliases = {
      st = "status";
      co = "checkout";
      ci = "commit";
      br = "branch";
      refgraph = "log --graph --all --simplify-by-decoration";
      dag = "log --graph --all";
    };

    # Global gitignore - todo, would be nice to symlink this.
    ignores = [
      # Temp files
      "*.swp"

      # Eclipse
      "eclipse-bin"

      # IntelliJ
      ".idea"
      "*.iml"

      # MacOS
      ".DS_Store"

      # direnv file usually should not be committed.
      ".envrc"
      ".env"

      # Claude
      "settings.local.json"

      # VS Code
      ".vscode"
      ".attach_pid*"

      # Yarn
      ".yarnrc.yml"
    ];

    # Conditional includes for different directories
    includes = [
      {
        condition = "gitdir:~/personal/";
        contents = {
          user = {
            name = "Jason Walker";
            email = "jason@onetrue.name";
          };
        };
      }
    ];
  };

  programs.lazygit.enable = true;
}
