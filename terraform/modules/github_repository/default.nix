{self, ...}: {
  self,
  nixpkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.justinrubek.githubRepositories;
in {
  options = {
    justinrubek.githubRepositories = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule ({
        name,
        config,
        ...
      }: {
        options = {
          description = lib.mkOption {
            description = "Description of the repository.";
            type = lib.types.str;
          };

          visibility = lib.mkOption {
            description = "Visibility of the repository.";
            type = lib.types.enum ["public" "private"];
            default = "public";
          };

          has_issues = lib.mkOption {
            description = "Whether the repository has issues enabled.";
            type = lib.types.bool;
            default = true;
          };

          has_discussions = lib.mkOption {
            description = "Whether the repository has discussions enabled.";
            type = lib.types.bool;
            default = true;
          };

          has_wiki = lib.mkOption {
            description = "Whether the repository has wiki enabled.";
            type = lib.types.bool;
            default = false;
          };

          has_projects = lib.mkOption {
            description = "Whether the repository has projects enabled.";
            type = lib.types.bool;
            default = false;
          };

          has_downloads = lib.mkOption {
            description = "Whether the repository has downloads enabled.";
            type = lib.types.bool;
            default = false;
          };

          allow_merge_commit = lib.mkOption {
            description = "Whether the repository allows merge commits.";
            type = lib.types.bool;
            default = false;
          };

          allow_squash_merge = lib.mkOption {
            description = "Whether the repository allows squash merging.";
            type = lib.types.bool;
            default = false;
          };

          allow_rebase_merge = lib.mkOption {
            description = "Whether the repository allows rebase merging.";
            type = lib.types.bool;
            default = true;
          };

          allow_auto_merge = lib.mkOption {
            description = "Whether the repository allows auto merging.";
            type = lib.types.bool;
            default = true;
          };

          delete_branch_on_merge = lib.mkOption {
            description = "Whether the repository deletes branches on merge.";
            type = lib.types.bool;
            default = true;
          };

          topics = lib.mkOption {
            description = "A list of topics for the repository.";
            default = null;
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
          };

          name = lib.mkOption {
            description = "Name of the repository.";
            type = lib.types.str;
            readOnly = true;
          };

          prevent_deletion = lib.mkOption {
            description = "A list of branches to prevent deletion of.";
            type = lib.types.listOf lib.types.str;
            default = ["main"];
          };

          repositoryResource = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
            description = "The repository configuration";
          };

          branchProtection = lib.mkOption {
            type = lib.types.listOf lib.types.unspecified;
            readOnly = true;
            description = "The branch protection configuration";
          };
        };

        config = {
          name = name;

          repositoryResource = {
            name = name;
            description = config.description;
            visibility = config.visibility;
            has_issues = config.has_issues;
            has_discussions = config.has_discussions;
            has_wiki = config.has_wiki;
            has_projects = config.has_projects;
            has_downloads = config.has_downloads;
            allow_merge_commit = config.allow_merge_commit;
            allow_squash_merge = config.allow_squash_merge;
            allow_rebase_merge = config.allow_rebase_merge;
            allow_auto_merge = config.allow_auto_merge;
            delete_branch_on_merge = config.delete_branch_on_merge;
            topics = config.topics;
          };

          branchProtection = builtins.map (branch: {
            name = "${config.name}-${branch}";
            value = {
              repository_id = "\${github_repository.${config.name}.id}";
              pattern = branch;
              allows_deletions = false;
            };
          })
          config.prevent_deletion;
        };
      }));
    };
  };

  config = let
    repositories = builtins.mapAttrs (name: config: config.repositoryResource) cfg;

    branchProtections = let
      branchProtection = builtins.mapAttrs (name: config: config.branchProtection) cfg;

      values = builtins.attrValues branchProtection;

      allValues = builtins.foldl' (acc: value: acc ++ value) [] values;
    in
      builtins.listToAttrs allValues;
  in {
    resource.github_repository = repositories;
    resource.github_branch_protection = branchProtections;
  };
}
