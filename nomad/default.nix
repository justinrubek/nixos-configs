{
  config,
  inputs,
  lib,
  self,
  ...
}: {
  perSystem = {
    config,
    pkgs,
    system,
    ...
  }: let
  in rec {
    packages = {
      nomadJobs = inputs.nix-nomad.lib.mkNomadJobs {
        inherit system;
        config = [
          ./jobs/dummy-api.nix
          ./jobs/dummy-api-nix.nix
          ./jobs/rubek-site.nix
          ./jobs/storage.nix
          ./jobs/valheim.nix
          ./jobs/jellyfin.nix
        ];
      };
    };
  };
}
