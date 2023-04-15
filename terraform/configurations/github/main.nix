{
  nomadJobs,
  pkgs,
  ...
}: {
  provider = {
    github = {};
    vault = {};
  };

  # TODO: retrieve kvv2_path from the vault configuration

  data.vault_kv_secret_v2 = {
    crates_io = {
      mount = "kv-v2";
      name = "github-env/crates-io";
    };
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

    calendar-scheduler = {
      description = "CalDav utility library and axum API for scheduling based on availability stored in a calendar";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["caldav" "calendar" "scheduler"];

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

      secrets = {
        CRATES_IO_TOKEN = {value = "\${data.vault_kv_secret_v2.crates_io.data.token}";};
      };
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

    nix-sqlx-example = {
      description = "Example of using sqlx in a nix flake, with pre-commit hooks";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["sqlx" "pre-commit" "example"];

      inherit prevent_deletion;
    };

    "rubek.dev" = {
      description = "My personal website";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["website" "astro" "svelte" "tailwind" "github-actions" "yarn" "dream2nix" "crane" "typescript"];

      inherit prevent_deletion;
    };

    wasm-bindgen-service-worker = {
      description = "A web service worker implementation using wasm_bindgen. This is a proof of concept using rust to initialize and manage a service worker";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["wasm-bindgen" "service-worker" "wasm" "web" "worker" "poc"];

      inherit prevent_deletion;
    };
  };
}
