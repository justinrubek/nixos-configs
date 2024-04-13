{
  self,
  nixpkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.justinrubek.nixosConfigurations;

  # collect all nixosConfigurations so they can be exposed as flake outputs
  configs = builtins.mapAttrs (_: config: config.nixosConfig) cfg;

  # TODO: determine if these are useful and where to expose them from
  packages = builtins.attrValues (builtins.mapAttrs (_: config: let
    # collect the configurations under an attribute set so they can be used
    # as flake.packages outputs
    namespaced = {${config.system}.${config.packageName} = config.nixosPackage;};
  in
    namespaced)
  cfg);
in {
  options = {
    justinrubek.nixosConfigurations = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({
        name,
        config,
        ...
      }: {
        options = {
          system = lib.mkOption {
            type = lib.types.enum ["x86_64-linux" "aarch64-linux"];
          };

          modules = lib.mkOption {
            type = lib.types.listOf lib.types.unspecified;
            default = [];
            description = "List of modules to include for the nixos configuration.";
          };

          nixosConfig = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
            description = "The nixos configuration.";
          };

          packageName = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            description = "The name of the exported package.";
          };

          nixosPackage = lib.mkOption {
            type = lib.types.package;
            readOnly = true;
            description = "The package output that contains the system's build.toplevel.";
          };
        };

        config = {
          nixosConfig = self.lib.nixosSystem {
            inherit (config) system modules;
            inherit name;
          };

          nixosPackage = config.nixosConfig.config.system.build.toplevel;
          packageName = "nixos/configuration/${name}";
        };
      }));
    };
  };

  config = {
    flake.nixosConfigurations = configs;
  };
}
