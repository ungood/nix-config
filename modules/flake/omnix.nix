_: {
  flake = {
    om = {
      ci.default.omnix = {
        dir = ".";

        # TODO: For now, this is disabled as the github runners do not have enough disk space
        # to build everything.
        steps.build.enable = false;
      };
    };
  };
}
