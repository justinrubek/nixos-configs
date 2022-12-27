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

  resource.nomad_volume.valheim_data = {
    depends_on = ["resource.nomad_job.storage_controller" "resource.nomad_job.storage_node"];
    type = "csi";
    plugin_id = "org.democratic-csi.nfs";
    volume_id = "valheim-data";
    name = "valheim-data";
    external_id = "valheim-data";

    capability = {
      access_mode = "single-node-writer";
      attachment_mode = "file-system";
    };

    context = {
      server = "alex";
      share = "/var/nfs/valheim/data";
      node_attach_driver = "nfs";
      provisioner_driver = "node-manual";
    };

    mount_options = {
      fs_type = "nfs";
      mount_flags = ["nfsvers=3" "hard" "async"];
    };
  };

  resource.nomad_volume.valheim_config = {
    depends_on = ["resource.nomad_job.storage_controller" "resource.nomad_job.storage_node"];
    type = "csi";
    plugin_id = "org.democratic-csi.nfs";
    volume_id = "valheim-config";
    name = "valheim-config";
    external_id = "valheim-config";

    capability = {
      access_mode = "single-node-writer";
      attachment_mode = "file-system";
    };

    context = {
      server = "alex";
      share = "/var/nfs/valheim/config";
      node_attach_driver = "nfs";
      provisioner_driver = "node-manual";
    };

    mount_options = {
      fs_type = "nfs";
      mount_flags = ["nfsvers=3" "hard" "async"];
    };
  };

  resource.nomad_job.valheim = {
    depends_on = ["resource.nomad_volume.valheim_data" "resource.nomad_volume.valheim_config"];
    jobspec = ''''${file("''${path.module}/jobs/valheim.nomad")}'';
    # jobspec = ''''${file("${nomad_jobs}/valheim.json")}'';
    # json = true;
  };
}
