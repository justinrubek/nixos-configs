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
    jobspec = ''''${file("${nomad_jobs}/dummy_api.json")}'';
    json = true;
  };

  resource.nomad_job.dummy_api_nix = {
    jobspec = ''''${file("${nomad_jobs}/dummy_api_nix.json")}'';
    json = true;
  };

  resource.nomad_job.rubek_site = {
    jobspec = ''''${file("${nomad_jobs}/rubek_site.json")}'';
    json = true;
  };
}
