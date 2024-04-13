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
  }: {
    packages = {
      nomadJobs = inputs.nix-nomad.lib.mkNomadJobs {
        inherit system;
        config = [
          ./jobs/dummy-api.nix
          ./jobs/dummy-api-nix.nix
          ./jobs/rubek-site.nix
          ./jobs/rubek-site-nix.nix
          ./jobs/storage.nix
          ./jobs/valheim.nix
          ./jobs/jellyfin.nix
          ./jobs/paperless.nix
          ./jobs/postgres.nix
          ./jobs/key-test.nix
          ./jobs/conduit.nix
          ./jobs/factorio.nix
          ./jobs/flake-builder.nix
          ./jobs/nix-cache.nix
          ./jobs/lockpad.nix
          ./jobs/annapurna.nix
        ];
      };
    };
  };
}
