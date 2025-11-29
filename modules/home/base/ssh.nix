{
  config,
  ...
}:
{
  # TODO: Don't set this for headless, since it will be forwarded from client.
  # TODO: Check that 1Password SSH Agent is running (that agent.sock exists)
  # See: http://github.com/mrjones2014/dotfiles
  home.sessionVariables = {
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        forwardAgent = true;
        identityAgent = "${config.home.homeDirectory}/.1password/agent.sock";
      };
    };

    # TODO: Setup forwarding AuthSock for servers
  };
}
