{self, ...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.justinrubek.nomad;
in {
  options.justinrubek.nomad = {
    enable = lib.mkEnableOption "run nomad";
  };

  config = lib.mkIf cfg.enable {
    services.nomad = {
      enable = true;
      enableDocker = true;

      # use patched nomad for flake support
      package = self.packages.${pkgs.system}.nomad;

      extraPackages = [config.nix.package];

      settings = {
        bind_addr = "0.0.0.0";
        datacenter = "dc1";

        server = {
          enabled = true;
          bootstrap_expect = 1;
        };

        client = {
          enabled = true;
          cni_path = "${pkgs.cni-plugins}/bin";
        };
      };
    };

    # ensure that docker is present
    justinrubek.development.containers = {
      enable = true;
      useDocker = true;
    };
  };
}
