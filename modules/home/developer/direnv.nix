{
  programs = {
    direnv = {
      enable = true;

      nix-direnv.enable = true;

      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };

    # direnv file usually should not be committed unless whitelisted.
    git.ignores = [
      ".envrc"
      ".env"
      ".env.*"
      ".direnv"
    ];
  };
}
