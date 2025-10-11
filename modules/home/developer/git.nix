{ lib, config, ... }:

# TODO: Add a way to configure git for work
let
  signingKeyConfigured = config.programs.git.signing.key != null;
  warningMessage = ''
    ⚠️  WARNING: Git commit signing is enabled but no signing key is configured.
       Please set your SSH public key for commit signing by adding to your configuration:
       programs.git.signing.key = "ssh-ed25519 AAAA...";
       Or add the key from 1Password to your git configuration.
  '';
in
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

  warnings = lib.optional (!signingKeyConfigured) warningMessage;
}
