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

      extraArgs = {
        depends_on = ["resource.nomad_job.storage_controller" "resource.nomad_job.storage_node"];
      };
    };

    valheim_config = {
      enable = true;

      server = "alex";
      path = "/var/nfs/valheim/config";

      extraArgs = {
        depends_on = ["resource.nomad_job.storage_controller" "resource.nomad_job.storage_node"];
      };
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
  };
}
