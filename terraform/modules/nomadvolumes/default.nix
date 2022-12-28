{self, ...}: {
  self,
  nixpkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.justinrubek.nomadVolumes;

  enabled = lib.attrsets.filterAttrs (_: config: config.enable) cfg;
  enabledResources = builtins.mapAttrs (_: config: config.volumeResource) enabled;
in {
  options = {
    justinrubek.nomadVolumes = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule ({
        name,
        config,
        ...
      }: {
        options = {
          enable = lib.mkEnableOption "Nomad volume ${name}";

          server = lib.mkOption {
            description = "address of NFS server";
            type = lib.types.str;
          };

          path = lib.mkOption {
            description = "path on NFS server";
            type = lib.types.str;
          };

          extraArgs = lib.mkOption {
            type = lib.types.attrsOf lib.types.unspecified;
            default = {};
          };

          volumeResource = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
            description = "The terraform nomad_volume resource";
          };
        };

        config = {
          volumeResource =
            {
              depends_on = ["resource.nomad_job.storage_controller" "resource.nomad_job.storage_node"];

              type = "csi";
              plugin_id = "org.democratic-csi.nfs";
              volume_id = name;
              name = name;
              external_id = name;

              capability = {
                access_mode = "single-node-writer";
                attachment_mode = "file-system";
              };

              context = {
                inherit (config) server;
                share = config.path;
                node_attach_driver = "nfs";
                provisioner_driver = "node-manual";
              };

              mount_options = {
                fs_type = "nfs";
                mount_flags = ["nfsvers=3" "hard" "async"];
              };
            }
            // config.extraArgs;
        };
      }));
    };
  };

  config = {
    resource.nomad_volume = enabledResources;
  };
}
