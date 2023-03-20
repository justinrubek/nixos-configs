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

    # quick short-hand for frequently used topics
    topics = {
      nix = ["nix"];
      flake = ["nix-flake" "flake"];
      rust = ["rust"];
      terraform = ["terraform"];
    };

    # Given a list of attr keys into `topics`, return a list of topic values.
    # e.g. mkTopic ["nix" "rust"] -> ["nix" "nix-flake" "rust"]
    mkTopic = groups: builtins.concatLists (builtins.map (group: topics.${group}) groups);
  in {
    annapurna = {
      description = "Recipe, cooking, and shopping helper featuring logical programming";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["ascent"];

      inherit prevent_deletion;
    };

    bomper = {
      description = "bump version strings in your files";
      topics = (mkTopic ["rust" "flake"]);

      inherit prevent_deletion;
    };

    inkmlrs = {
      description = "Create and render InkML documents";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["inkml"];

      prevent_deletion = ["master"];
    };

    lockpad = {
      description = "Simplistic login system";

      inherit prevent_deletion;
    };

    templates = {
      description = "Quick start project templates. My common boilerplate goes here";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["templates"];

      inherit prevent_deletion;
    };

    thoenix = {
      description = "Manage terraform configurations using terranix";
      topics = (mkTopic ["nix" "rust" "flake" "terraform"]);

      inherit prevent_deletion;
    };
  };
}
