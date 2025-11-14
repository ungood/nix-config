{
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      config = {
        global.load_dotenv = true;
      };
    };

    # direnv file usually should not be committed.
    git.ignores = [
      ".envrc"
      ".env"
      ".env.*"
      ".direnv"
    ];
  };
}
