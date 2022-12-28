{
  inputs,
  self,
  ...
}: let
  # TODO: Rewrite modules to have better inputs
  moduleInput = {
    inherit inputs self;
  };
in {
  flake.terraformModules = {
    nomadjob = import ./nomadjob moduleInput;
  };
}
