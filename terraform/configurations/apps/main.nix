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

  resource.nomad_job.rubek_site = {
    jobspec = ''''${file("${nomad_jobs}/rubek_site.json")}'';
    json = true;
  };

  resource.nomad_job.storage_controller = {
    jobspec = ''''${file("${nomad_jobs}/storage_controller.json")}'';
    json = true;
  };

  resource.nomad_job.storage_node = {
    jobspec = ''''${file("${nomad_jobs}/storage_node.json")}'';
    json = true;
  };

  resource.nomad_volume.valheim = {
    depends_on = ["resource.nomad_job.storage_controller" "resource.nomad_job.storage_node"];
    type = "csi";
    plugin_id = "org.democratic-csi.nfs";
    volume_id = "valheim";
    name = "valheim";
    external_id = "valheim";

    capability = {
      access_mode = "single-node-writer";
      attachment_mode = "file-system";
    };

    context = {
      server = "alex";
      share = "/var/nfs/valheim";
      node_attach_driver = "nfs";
      provisioner_driver = "node-manual";
    };

    mount_options = {
      fs_type = "nfs";
      mount_flags = ["nfsvers=3" "hard" "async"];
    };
  };
}
