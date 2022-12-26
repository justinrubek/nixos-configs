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
}
