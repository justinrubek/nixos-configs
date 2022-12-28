{
  nomadJobs,
  pkgs,
  ...
}: let
  system = pkgs.system;

  nomad_jobs = nomadJobs;
in {
  # configure hcloud
  provider = {
    nomad = {};
  };

  justinrubek.nomadVolumes = {
    valheim_data = {
      enable = true;

      server = "alex";
      path = "/var/nfs/valheim/data";
    };

    valheim_config = {
      enable = true;

      server = "alex";
      path = "/var/nfs/valheim/config";
    };

    jellyfin_cache = {
      enable = true;

      server = "alex";
      path = "/var/nfs/jellyfin/cache";
    };

    jellyfin_config = {
      enable = true;

      server = "alex";
      path = "/var/nfs/jellyfin/config";
    };

    jellyfin_media = {
      enable = true;

      server = "alex";
      path = "/var/nfs/jellyfin/media";
    };
  };

  justinrubek.nomadJobs = {
    valheim = {
      enable = true;
      jobspec = "${nomad_jobs}/valheim.json";
      extraArgs = {
        depends_on = ["resource.nomad_volume.valheim_data" "resource.nomad_volume.valheim_config"];
      };
    };

    rubek_site = {
      enable = true;
      jobspec = "${nomad_jobs}/rubek_site.json";
    };

    storage_controller = {
      enable = true;
      jobspec = "${nomad_jobs}/storage_controller.json";
    };

    storage_node = {
      enable = true;
      jobspec = "${nomad_jobs}/storage_node.json";
    };

    jellyfin = {
      enable = true;
      jobspec = "${nomad_jobs}/jellyfin.json";
      extraArgs = {
        depends_on = ["resource.nomad_volume.jellyfin_cache" "resource.nomad_volume.jellyfin_config" "resource.nomad_volume.jellyfin_media"];
      };
    };
  };
}
