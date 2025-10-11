{ lib, config, ... }:

# TODO: Add a way to configure git for work
{
  programs.git = {
    enable = true;

    extraConfig = {
      # Enable SSH-based commit signing using 1Password
      # https://developer.1password.com/docs/ssh/git-commit-signing
      gpg = {
        format = "ssh";
        ssh = {
          program = "op-ssh-sign";
        };
      };
      commit = {
        gpgsign = true;
      };
    };
  };

  # Display warning if user hasn't configured their signing key
  home.activation.warnMissingSigningKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -z "$(${config.programs.git.package}/bin/git config --global user.signingkey 2>/dev/null || true)" ]; then
      echo "⚠️  WARNING: Git commit signing is enabled but no signing key is configured."
      echo "   Please set your SSH public key for commit signing:"
      echo "   git config --global user.signingkey 'ssh-ed25519 AAAA...'"
      echo "   Or add the key from 1Password to your git configuration."
    fi
  '';
}
