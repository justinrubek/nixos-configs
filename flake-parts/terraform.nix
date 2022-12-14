{
  inputs,
  self,
  ...
} @ part-inputs: {
  imports = [];

  perSystem = {
    self',
    pkgs,
    lib,
    system,
    inputs',
    ...
  }: let
    # the providers to be available for terraform
    # see "nixpkgs/pkgs/applications/networking/cluster/terraform-providers/providers.json"
    terraformPluginsPredicate = p: [
      p.hcloud
      # p.kubernetes
      # p.nomad
      # p.null
      # p.local
      p.random
      # p.template
      # p.tls
      # p.tfe
      # p.vault
    ];
    terraform = pkgs.terraform.withPlugins terraformPluginsPredicate;

    # alias the terraform command to execute within the proper directory
    terraform-command = let
      jq = "${pkgs.jq}/bin/jq";
      terraform-cli = "${self'.packages.terraform}/bin/terraform";
    in
      pkgs.writeShellScriptBin "tnix" ''
        set -euo pipefail
        # accept the configuration name as the first argument
        # use it to add a -chdir=''${configurationPath} argument to the terraform command

        # get the configuration name
        configurationName="$1"
        shift

        # navigate to the top-level directory before executing the terraform command
        pushd $(git rev-parse --show-toplevel)

        # determine the path to the configuration
        configurationPath=$(cat ${self'.packages.terraformConfigurationMatrix}/terraform-configuration-matrix.json | ${jq} -r '.configurations[] | select(.name == "'$configurationName'" ) | .path')

        # copy the generated terraform configuration to the configuration path
        cp "$configurationPath/config.tf.json" ./terraform/configurations/$configurationName/config.tf.json

        # execute the terraform command
        ${terraform-cli} -chdir=./terraform/configurations/$configurationName "$@"

        # return to the original directory
        popd
      '';

    # push the current configuration to terraform cloud
    # this is useful for doing API-driven terraform runs
    # https://developer.hashicorp.com/terraform/cloud-docs/run/api#pushing-a-new-configuration-version
    push-configuration = let
      jq = "${pkgs.jq}/bin/jq";
      curl = "${pkgs.curl}/bin/curl";
      terraform-cli = "${self'.packages.terraform}/bin/terraform";
    in
      pkgs.writeShellScriptBin "tfcloud-push" ''
        set -euo pipefail
        # accept the configuration name as the first argument

        # get the configuration name
        configurationName="$1"
        shift
        # get the workspace name
        workspaceName="$1"
        shift

        # organization name (from env)
        : ''${TFE_ORG?"TFE_ORG must be set"}
        # tfcloud token (from env)
        : ''${TFE_TOKEN?"TFE_TOKEN must be set"}
        # tfcloud url (from env, defaults to app.terraform.io)
        if [ -z "''${TFE_URL:-}" ]; then
          TFE_URL="app.terraform.io"
        fi

        echo "TFE_ORG: $TFE_ORG"
        echo "TFE_URL: $TFE_URL"

        # the configuration will be pushed inside a tarball
        file_name="./content-$(date +%s).tar.gz"

        # settings for the configuration version to be created
        echo '{"data":{"type":"configuration-versions"}}' > ./create_config_version.json

        __cleanup ()
        {
          # remove the tarball
          rm $file_name
          # remove the json file
          rm ./create_config_version.json
          # return to the original directory
          popd
        }

        # navigate to the top-level directory before executing the terraform command
        pushd $(git rev-parse --show-toplevel)

        # trap cleanup on exit
        trap __cleanup EXIT

        # place the configuration's directory into a tarball
        nix build .#terraformConfiguration_$configurationName
        tar -zcvf $file_name -C ./result .

        # lookup the workspace id
        workspace_id=($(curl \
          --header "Authorization: Bearer $TFE_TOKEN" \
          --header "Content-Type: application/vnd.api+json" \
          https://''$TFE_URL/api/v2/organizations/$TFE_ORG/workspaces/''$workspaceName \
          | ${jq} -r '.data.id'))

        # create a new configuration version
        upload_url=($(curl \
          --header "Authorization: Bearer $TFE_TOKEN" \
          --header "Content-Type: application/vnd.api+json" \
          --request POST \
          --data @create_config_version.json \
          https://''$TFE_URL/api/v2/workspaces/$workspace_id/configuration-versions \
          | ${jq} -r '.data.attributes."upload-url"'))

        # finally, upload the configuration content to the newly created configuration version
        echo "upload_url: $upload_url"
        curl \
          --header "Content-Type: application/octet-stream" \
          --request PUT \
          --data-binary @"$file_name" \
          $upload_url

      '';
  in rec {
    packages = {
      # expose terraform with the pinned providers
      inherit terraform;
      inherit terraform-command push-configuration;
    };

    apps = let
      jq = "${pkgs.jq}/bin/jq";

      # print the list of pinnable terraform providers from nixpkgs
      terraform-provider-pins = pkgs.writeShellScriptBin "terraform-provider-pins" ''
        cat ${inputs.nixpkgs}/pkgs/applications/networking/cluster/terraform-providers/providers.json
      '';
    in {
      printTerraformProviders = {
        type = "app";
        program = pkgs.lib.getExe terraform-provider-pins;
      };
    };
  };
}
