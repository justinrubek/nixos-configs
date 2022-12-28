{self, ...}: {
  self,
  nixpkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.justinrubek.nomadJobs;

  jobs = builtins.mapAttrs (_: config: config.jobResource) cfg;

  # do the same as `jobs`, except only include jobs that are enabled
  enabled = lib.attrsets.filterAttrs (_: config: config.enable) cfg;
  enabledJobs = builtins.mapAttrs (_: config: config.jobResource) enabled;
in {
  options = {
    justinrubek.nomadJobs = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule ({
        name,
        config,
        ...
      }: {
        options = {
          enable = lib.mkEnableOption "Nomad job ${name}";

          jobspec = lib.mkOption {
            description = "Path to jobspec file";
            type = lib.types.str;
          };

          extraArgs = lib.mkOption {
            type = lib.types.attrsOf lib.types.unspecified;
            default = {};
          };

          jobResource = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
            description = "The terraform nomad_job resource";
          };
        };

        config = {
          jobResource =
            {
              jobspec = ''''${file("${config.jobspec}")}'';
              json = true;
            }
            // config.extraArgs;
        };
      }));
    };
  };

  config = {
    resource.nomad_job = enabledJobs;
  };
}
