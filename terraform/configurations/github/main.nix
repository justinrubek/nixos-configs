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

    docker_io = {
      mount = "kv-v2";
      name = "github-env/docker-io";
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
      bevy = ["bevy" "bevyengine" "game"];
    };

    # Given a list of attr keys into `topics`, return a list of topic values.
    # e.g. mkTopic ["nix" "rust"] -> ["nix" "nix-flake" "rust"]
    mkTopic = groups: builtins.concatLists (builtins.map (group: topics.${group}) groups);
  in {
    annapurna = {
      description = "Recipe, cooking, and shopping helper featuring logical programming";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["ascent"];

      inherit prevent_deletion;

      homepage_url = "https://annapurna.rubek.cloud";
    };

    async-watcher = {
      description = "A file notification library for tokio";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["async" "file-watcher"];

      inherit prevent_deletion;

      secrets = {
        CRATES_IO_TOKEN = {value = "\${data.vault_kv_secret_v2.crates_io.data.token}";};
      };
    };

    ayysee = {
      description = "A custom programming language for Stationeers integrated circuits";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["stationeers" "language" "compiler"];

      inherit prevent_deletion;

      pages = {
        source = {
          branch = "gh-pages";
          path = "/";
        };
      };
      homepage_url = "https://justinrubek.github.io/ayysee/";
    };

    bevy-template = {
      description = "A template for bevy games";
      topics = (mkTopic ["nix" "rust" "flake" "bevy"]) ++ ["template"];
      is_template = true;

      prevent_deletion = []; # ensure main has no protection
    };

    bomper = {
      description = "bump version strings in your files";
      topics = mkTopic ["rust" "flake"];

      inherit prevent_deletion;
    };

    calendar-scheduler = {
      description = "CalDav utility library and axum API for scheduling based on availability stored in a calendar";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["caldav" "calendar" "scheduler"];

      inherit prevent_deletion;
    };

    cheesecalc = {
      description = "Calculates ratios used for my mac and cheese";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["cooking" "recipe" "wasm"];

      inherit prevent_deletion;

      pages = {
        source = {
          branch = "gh-pages";
          path = "/";
        };
      };
      homepage_url = "https://justinrubek.github.io/cheesecalc/";
    };

    factorio-server = {
      description = "Factorio server container image";
      topics = (mkTopic ["nix" "flake"]) ++ ["factorio" "game" "game-server"];

      inherit prevent_deletion;

      secrets = {
        DOCKER_HUB_TOKEN = {value = "\${data.vault_kv_secret_v2.docker_io.data.token}";};
        DOCKER_HUB_USERNAME = {value = "\${data.vault_kv_secret_v2.docker_io.data.username}";};
      };

      homepage_url = "https://hub.docker.com/repository/docker/justinrubek/factorio-server/";
    };

    generation-toolkit = {
      description = "A collection of tools for working with generative models. This is a work in progress as I need more tools for my own use cases";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["openai" "gpt" "llm" "stable-diffusion" "image-generation" "text2image" "diffusion" "libtorch"];

      inherit prevent_deletion;
    };

    global-keybind = {
      description = "Use evdev to send a specific input event to X windows when using Wayland";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["wayland" "x11" "evdev" "input" "keybind"];

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

    matrix-bot = {
      description = "A work-in-progress matrix bot for my personal matrix server. I am using this to learn how to interact with matrix and to build a bot that can help me with my personal technology infrastructure";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["matrix" "chatbot"];

      inherit prevent_deletion;
    };

    nix-postgres = {
      description = "An opinionated postgresql";
      topics = (mkTopic ["nix" "flake"]) ++ ["postgres" "postgresql"];
    };

    nixos-configs = {
      description = "My 'dotfiles'. A collection of nixos configurations and other declarative infrastructure for my personal computing infrastructure";
      topics = (mkTopic ["nix" "flake"]) ++ ["dotfiles" "nixos"];

      inherit prevent_deletion;

      secrets = {
        DOCKER_HUB_TOKEN = {value = "\${data.vault_kv_secret_v2.docker_io.data.token}";};
        DOCKER_HUB_USERNAME = {value = "\${data.vault_kv_secret_v2.docker_io.data.username}";};
      };
    };

    nutmeg = {
      description = "A game proof of concept. This is an unfinished game originally intended for bevy jam 2";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["game" "bevy" "jam" "bevy-jam"];

      inherit prevent_deletion;

      pages = {
        source = {
          branch = "gh-pages";
          path = "/";
        };
      };
      homepage_url = "https://justinrubek.github.io/nutmeg/";
    };

    project-runner = {
      description = "A tool/library that detects and describes details about a project. This is a work in progress and is intended to be used as a library for other tools to build on top of and provide a consistent experience for interactions.";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["project" "runner" "prj"];

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
      topics = mkTopic ["nix" "rust" "flake" "terraform"];

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

      homepage_url = "https://rubek.dev";

      secrets = {
        DOCKER_HUB_TOKEN = {value = "\${data.vault_kv_secret_v2.docker_io.data.token}";};
        DOCKER_HUB_USERNAME = {value = "\${data.vault_kv_secret_v2.docker_io.data.username}";};
      };
    };

    wasm-bindgen-service-worker = {
      description = "A web service worker implementation using wasm_bindgen. This is a proof of concept using rust to initialize and manage a service worker";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["wasm-bindgen" "service-worker" "wasm" "web" "worker" "poc"];

      inherit prevent_deletion;
    };

    wayland-playground = {
      description = "My space for experimenting with wayland";
      topics = (mkTopic ["nix" "rust" "flake"]) ++ ["wayland" "smithay" "smithay-client-toolkit"];

      inherit prevent_deletion;
    };
  };
}
