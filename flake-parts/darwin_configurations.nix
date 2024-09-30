{
  self,
  nixpkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.justinrubek.darwinConfigurations;

  configs = builtins.mapAttrs (_: config: config.darwinConfig) cfg;

  packages = builtins.attrValues (builtins.mapAttrs (_: config: let
    # collect the configurations under an attribute set so they can be used
    # as flake.packages outputs
    namespaced = {${config.system}.${config.packageName} = config.darwinPackage;};
  in
    namespaced)
  cfg);
in {
  options = {
    justinrubek.darwinConfigurations = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({
        name,
        config,
        ...
      }: {
        options = {
          system = lib.mkOption {
            type = lib.types.enum ["aarch64-darwin"];
          };

          modules = lib.mkOption {
            type = lib.types.listOf lib.types.unspecified;
            default = [];
            description = "List of modules to include for the darwin configuration.";
          };

          darwinConfig = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
            description = "The darwin configuration.";
          };

          packageName = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            description = "The name of the exported package.";
          };

          darwinPackage = lib.mkOption {
            type = lib.types.package;
            readOnly = true;
            description = "The package output that contains the system's build.toplevel.";
          };
        };

        config = let
          configDir = "${self}/darwin/configurations/${name}";
          entryPoint = import configDir (inputs // {inherit self;});
        in {
          darwinConfig = inputs.nix-darwin.lib.darwinSystem {
            inherit (config) system;
            modules =
              config.modules
              ++ [entryPoint]
              ++ [
                {
                  nixpkgs.hostPlatform = "aarch64-darwin";
                }
              ];
          };

          darwinPackage = config.nixosConfig.config.system.build.toplevel;
          packageName = "nixos/configuration/${name}";
        };
      }));
    };
  };

  config = {
    flake.darwinConfigurations = configs;
  };
}
