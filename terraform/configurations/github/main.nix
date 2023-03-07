{
  nomadJobs,
  pkgs,
  ...
}: let
  system = pkgs.system;
in {
  provider = {
    github = {};
  };

  justinrubek.githubRepositories = {
    lockpad = {
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

      prevent_deletion = [
        "main"
      ];
    };

    templates = {
      name = "templates";
      description = "Quick start project templates. My common boilerplate goes here.";

      visibility = "public";

      has_issues = true;
      has_discussions = true;

      # Enable rebase merge only
      allow_merge_commit = false;
      allow_squash_merge = false;
      allow_rebase_merge = true;
      allow_auto_merge = true;

      delete_branch_on_merge = true;

      topics = ["nix" "nix-flake" "rust" "templates"];

      prevent_deletion = [
        "main"
      ];
    };
  };
}
