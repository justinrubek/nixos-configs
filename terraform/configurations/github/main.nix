{
  nomadJobs,
  pkgs,
  ...
}: {
  provider = {
    github = {};
  };

  justinrubek.githubRepositories = let
    prevent_deletion = [
      "main"
    ];

    topics = {
      nix = ["nix" "nix-flake"];
      rust = ["rust"];
    };

    # Given a list of attr keys into `topics`, return a list of topic values.
    # e.g. mkTopic ["nix" "rust"] -> ["nix" "nix-flake" "rust"]
    mkTopic = groups: builtins.concatLists (builtins.map (group: topics.${group}) groups);
  in {
    lockpad = {
      description = "Simplistic login system";

      inherit prevent_deletion;
    };

    templates = {
      description = "Quick start project templates. My common boilerplate goes here";
      topics = (mkTopic ["nix" "rust"]) ++ ["templates"];

      inherit prevent_deletion;
    };

    annapurna = {
      description = "Recipe, cooking, and shopping helper featuring logical programming";
      topics = (mkTopic ["nix" "rust"]) ++ ["ascent"];

      inherit prevent_deletion;
    };
  };
}
