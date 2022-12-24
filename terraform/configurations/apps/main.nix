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

  resource.nomad_job.dummy_api = {
    # jobspec = builtins.readFile "${nomad_jobs}/dummy_api.json";
    jobspec = ''''${file("${nomad_jobs}/dummy_api.json")}'';
    json = true;
  };
}
