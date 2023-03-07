{
  nomadJobs,
  pkgs,
  ...
}: {
  provider = {
    github = {};
  };

  justinrubek.githubRepositories = {
    lockpad = {
      description = "Simplistic login system";

      prevent_deletion = [
        "main"
      ];
    };

    templates = {
      description = "Quick start project templates. My common boilerplate goes here.";
      topics = ["nix" "nix-flake" "rust" "templates"];

      prevent_deletion = [
        "main"
      ];
    };
  };
}
