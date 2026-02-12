_: {
  programs = {
    television = {
      enable = true;
      enableFishIntegration = true;

      channels = {
        fish-history = {
          metadata = {
            name = "fish-history";
          };

          source = {
            command = "fish -c 'history'";
            no_sort = true;
            frecency = false;
          };
        };
      };
    };

    # TODO: This would be interesting to replace/extend delta as a pager for git diffs
    # TODO: Add plasma-manager, etc... to nix-search index
    # TODO: Combine with comma and nix-locate/nix-index?
  };
}
