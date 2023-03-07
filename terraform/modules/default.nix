{
  inputs,
  self,
  ...
} @ module-input: let
in {
  flake.terraformModules = {
    nomadjob = import ./nomadjob module-input;
    nomadvolumes = import ./nomadvolumes module-input;
    github_repository = import ./github_repository module-input;
  };
}
