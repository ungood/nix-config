_: {
  programs = {
    television = {
      enable = true;
      enableFishIntegration = true;
    };

    nix-search-tv = {
      enable = true;
      enableTelevisionIntegration = true;
    };

    # TODO: This would be interesting to replace/extend delta as a pager for git diffs
    # TODO: Add plasma-manager, etc... to nix-search index
    # TODO: Combine with comma and nix-locate/nix-index?
  };
}
