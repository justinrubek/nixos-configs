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
        pkgs.awscli
        pkgs.kind
        pkgs.kops
        pkgs.kubectl
        pkgs.kubernetes-helm
        pkgs.podman
        pkgs.sops
        pkgs.terraform
        pkgs.vfkit
      ];

      sessionPath = ["$HOME/go/bin"];

      stateVersion = "24.05";
    };
  };
}
