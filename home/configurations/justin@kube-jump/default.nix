{comma, ...} @ inputs: {
  pkgs,
  flakeRootPath,
  ...
}: {
  config = {
    activeProfiles = ["development"];

    justinrubek = {
      development.containers = {
        enable = true;
        useDocker = true;
      };
    };

    home = {
      stateVersion = "24.05";
    };
  };
}
