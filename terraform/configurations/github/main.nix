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
    github = {};
  };

  resource.github_repository."lockpad" = {
    name = "lockpad";
    description = "Simplistic login system";

    visibility = "public";

    has_issues = true;
    has_discussions = true;

    # Enable rebase merge only
    allow_merge_commit = false;
    allow_squash_merge = false;
    allow_rebase_merge = true;
    allow_auto_merge = true;

    delete_branch_on_merge = true;
  };

  resource.github_branch_protection."lockpad-main" = {
    repository_id = "\${github_repository.lockpad.id}";

    pattern = "main";

    allows_deletions = false;
  };
}
