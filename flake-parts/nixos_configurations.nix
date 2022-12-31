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

          configDirectory = lib.mkOption {
            type = lib.types.str;
            default = "${self}/nixos/configurations/${name}";
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

          finalModules = lib.mkOption {
            type = lib.types.listOf lib.types.unspecified;
            readOnly = true;
            description = "All modules that are included in the nixos configuration.";
          };

          entryPoint = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
            description = ''
              The primary system configuration module.
              This is intended to be used for the bulk of the system configuration.
            '';
          };

          bootloader = lib.mkOption {
            type = lib.types.unspecified;
            description = "The system's bootloader configuration.";
            default = "${config.configDirectory}/bootloader.nix";
          };

          hardware = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
            description = "The system's hardware-specific configuration.";
          };
        };

        config = {
          entryPoint = import config.configDirectory (inputs // {inherit self;});
          bootloader = "${config.configDirectory}/bootloader.nix";
          hardware = "${config.configDirectory}/hardware.nix";

          finalModules =
            [
            ]
            ++ config.modules
            ++ builtins.attrValues {
              inherit (config) entryPoint bootloader hardware;
            };

          nixosConfig = self.lib.nixosSystem {
            inherit (config) system;
            modules = config.finalModules;
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
