_: {
  programs = {
    git = {
      enable = true;

      # Managed by 1 password
      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGornGQM0bR7SEJMtTE3Lk6sg06ys2VU9PFVEGtaCLus";

      settings = {
        # Do not guess defaults for user.email and user.name
        user = {
          useConfigOnly = true;
          name = "Jason Walker";
          email = "jason@onetrue.name";
        };

        core = {
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

        alias = {
          st = "status";
          co = "checkout";
          br = "branch";
          refgraph = "log --graph --all --simplify-by-decoration";
          dag = "log --graph --all";
        };
      };

      # Global gitignore - todo, would be nice to symlink this.
      ignores = [
        # Temp files
        "*.swp"

        # MacOS
        ".DS_Store"
      ];

      # Conditional includes for different directories
      # TODO: this doesn't really do anything yet since I don't have a separate work config.
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

    lazygit.enable = true;

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        side-by-side = true;
        line-numbers = true;
        navigate = true;
      };
    };
  };
}
