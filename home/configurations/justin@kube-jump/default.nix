{comma, ...} @ inputs: {
  pkgs,
  flakeRootPath,
  ...
}: {
  config = {
    activeProfiles = ["development"];

    home = {
      stateVersion = "24.05";
    };
  };
}
