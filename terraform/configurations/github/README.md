# GitHub repository management

This workspace provides an opinionated configuration for repository management.
By default repositories will only allow rebase merging.

GitHub repositories are commonly created through GitHub's UI, and not managed through terraform.
If you wish to use terraform to manage them then they will have to be imported.
First, set up the terraform configuration for the repository, then import it before running an apply.
To import it you must match the name of the terraform resource to the repository name: `thoenix terraform github import github_repository.${resource_name} ${repo_name}`.
In this configuration `resource_name` and `repo_name` should be the same thing-- the repository's name.
The GitHub provider is per-account/org and so the owner does not have to be specified.
