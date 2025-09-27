# System-wide 1Password configuration
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    # TODO It would be nice if this was configured from the users list.
    polkitPolicyOwners = [
      "ungood"
      "trafficcone"
      "abirdnamed"
    ];
  };

  # TODO: Shell Plugins https://developer.1password.com/docs/cli/shell-plugins/nix/
}
