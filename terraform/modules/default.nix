{ inputs, self, ... }@module-input:
{
  flake.terraformModules = {
    nomadjob = import ./nomadjob module-input;
    nomadvolumes = import ./nomadvolumes module-input;
    github_repository = import ./github_repository module-input;
  };
}
