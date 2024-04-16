{
  inputs,
  self,
  lib,
  ...
}:
{
  imports = [ ];

  perSystem =
    {
      self',
      pkgs,
      lib,
      system,
      inputs',
      ...
    }:
    let
      skopeo-push = pkgs.writeShellScriptBin "skopeo-push" ''
        set -euo pipefail
        # copy an image to a docker registry
        # 1. image - Given as a path to an image archive
        # 2. registry - The registry to push to
        ${pkgs.skopeo}/bin/skopeo copy --insecure-policy "docker-archive:$1" "docker://$2"
      '';

      paperless-base = pkgs.dockerTools.pullImage {
        imageName = "paperlessngx/paperless-ngx";
        imageDigest = "sha256:9948208107c66a63ca6ea987197a20a3d49bddd28cebf768be53b191dc54a9b7";
        sha256 = "sha256-w8189iaojdptL4JItHhCFVdTEX+A02TrKpzqCxXOB60=";
        finalImageTag = "paperless-base";
        finalImageName = "paperless";
      };
    in
    {
      apps = {
        skopeo-push = {
          type = "app";
          program = "${skopeo-push}/bin/skopeo-push";
        };
      };
      packages = {
        "scripts/skopeo-push" = skopeo-push;

        "image/paperless" = pkgs.dockerTools.buildImage {
          name = "paperless";
          tag = "latest";

          fromImage = paperless-base;

          copyToRoot = pkgs.buildEnv {
            name = "image-root";
            paths = [ pkgs.redis ];
            pathsToLink = [ "/bin" ];
          };

          config.Cmd = [ "/usr/local/bin/paperless_cmd.sh" ];
        };

        "image/conduit" = inputs'.conduit.packages."image/conduit";
      };
    };
}
