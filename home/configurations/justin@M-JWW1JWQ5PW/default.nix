inputs: {
  pkgs,
  flakeRootPath,
  ...
}: {
  config = {
    activeProfiles = ["development"];

    home = {
      packages = with pkgs; [
        pkgs.tokei
        inputs.nix-go.packages.${pkgs.system}.go
      ];

      stateVersion = "24.05";
    };
  };
}
