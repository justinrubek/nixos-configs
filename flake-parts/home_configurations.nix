{
  self,
  nixpkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.justinrubek.homeConfigurations;

  # collect all homeConfigurations so they can be exposed as flake outputs
  configs = builtins.mapAttrs (_: config: config.homeConfig) cfg;
in {
  options = {
    justinrubek.homeConfigurations = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({
        name,
        config,
        ...
      }: let
        # determine the username and hostname from the name
        splitName = builtins.split "@" name;
        username = builtins.elemAt splitName 0;
        hostname = builtins.elemAt splitName 2;
      in {
        options = {
          nixpkgs = {
            type = lib.types.unspecified;
            default = inputs.nixpkgs;
          };

          system = lib.mkOption {
            type = lib.types.enum ["x86_64-linux" "aarch64-linux"];
          };

          username = lib.mkOption {
            type = lib.types.str;
            default = username;
          };

          hostname = lib.mkOption {
            type = lib.types.str;
            default = hostname;
          };

          modules = lib.mkOption {
            type = lib.types.listOf lib.types.unspecified;
            default = [];
            description = "List of modules to include for the home-manager configuration.";
          };

          # outputs
          homeDirectory = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            description = "The path to the home directory of the user.";
          };

          homeConfig = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
            description = "The home-manager configuration.";
          };

          homePackage = lib.mkOption {
            type = lib.types.package;
            readOnly = true;
            description = "The home-manager activation package.";
          };

          finalModules = lib.mkOption {
            type = lib.types.listOf lib.types.unspecified;
            readOnly = true;
            description = "All modules that are included in the home-manager configuration.";
          };

          entryPoint = lib.mkOption {
            type = lib.types.unspecified;
            readOnly = true;
            description = "The entry point module of the home-manager configuration.";
          };
        };

        config = {
          entryPoint = import "${self}/home/configurations/${config.username}@${config.hostname}" (inputs // {inherit self;});
          homeDirectory = "/home/${config.username}";

          finalModules =
            [
              config.entryPoint
              {
                home = {
                  inherit (config) username homeDirectory;
                };
              }
              {
                nixpkgs = {
                  # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1119760100
                  # config.allowUnfree = true;
                  config.allowUnfreePredicate = (name: true);
                  config.xdg.configHome = "${config.homeDirectory}/.config";
                  overlays = [
                    inputs.nurpkgs.overlay
                  ];
                };
              }
            ]
            ++ config.modules
            # include this flake's modules
            ++ builtins.attrValues self.homeModules
            ++ builtins.attrValues self.modules;

          homeConfig = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.${config.system};
            modules = config.finalModules;
            extraSpecialArgs = {
              inherit (config) username;
            };
          };
        };
      }));
    };
  };

  config = {
    flake.homeConfigurations = configs;
  };
}
