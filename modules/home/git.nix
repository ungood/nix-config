_:

# TODO: Add a way to configure git for work
{
  programs.git = {
    enable = true;
    userName = "Jason Walker";
    userEmail = "jason@onetrue.name";

    extraConfig = {
      # TODO: Consider signing commits
      # https://developer.1password.com/docs/ssh/git-commit-signing
      # gpg = {
      #  format = "ssh"
      #  ssh = {
      #    program = "op-ssh-sign"
      #  };
      #}
    };
  };
}
