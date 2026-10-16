{ lib, pkgs, ... }:
let
  cableDir = "${pkgs.television.src}/cable/unix";

  fromUpstream = name: builtins.fromTOML (builtins.readFile "${cableDir}/${name}.toml");

  # Upstream binds ctrl-d to an immediate `kubectl delete` of the selection.
  withoutDelete =
    channel:
    channel
    // {
      keybindings = lib.filterAttrs (_: action: action != "actions:delete") (channel.keybindings or { });
      actions = removeAttrs (channel.actions or { }) [ "delete" ];
      metadata = channel.metadata // {
        description = lib.concatStringsSep "\n" (
          lib.filter (line: !lib.hasPrefix "Press `ctrl-d`" line) (
            lib.splitString "\n" channel.metadata.description
          )
        );
      };
    };
in
{
  # Contexts are left to ~/.kube/config, e.g. via
  # `aws eks update-kubeconfig --profile dev --name mx-dev-cac1-app --alias dev`.
  home.packages = [ pkgs.kubectl ];

  programs = {
    k9s.enable = true;

    television.channels = lib.genAttrs [
      "k8s-contexts"
      "k8s-deployments"
      "k8s-pods"
      "k8s-services"
    ] (name: withoutDelete (fromUpstream name));
  };
}
