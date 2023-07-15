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

  # TODO: determine if these are useful and where to expose them from
  packages = builtins.attrValues (builtins.mapAttrs (_: config: let
    # collect the configurations under an attribute set so they can be used
    # as flake.packages outputs
    namespaced = {${config.system}.${config.packageName} = config.homePackage;};
  in
    namespaced)
  cfg);
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

          packageName = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            description = "The name of the exported package output that contains the home-manager activation package.";
          };
        };

        config = let
          pkgs = inputs.nixpkgs.legacyPackages.${config.system};

          homeDirectory =
            if !pkgs.stdenv.isDarwin
            then "/home/${config.username}"
            else "/Users/${config.username}";
        in {
          entryPoint = import "${self}/home/configurations/${config.username}@${config.hostname}" (inputs // {inherit self;});
          inherit homeDirectory;

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
                  config.allowUnfreePredicate = name: true;
                  config.xdg.configHome = "${config.homeDirectory}/.config";
                  overlays = [
                    inputs.nurpkgs.overlay
                  ];
                };
              }
            ]
            ++ config.modules
            ++ [
              inputs.hyprland.homeManagerModules.default
            ]
            # include this flake's modules
            ++ builtins.attrValues self.homeModules
            ++ builtins.attrValues self.modules;

          homeConfig = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = config.finalModules;
            extraSpecialArgs = {
              inherit (config) username;
              inherit homeDirectory;
            };
          };

          homePackage = config.homeConfig.activationPackage;
          packageName = "home/configuration/${name}";
        };
      }));
    };
  };

  config = {
    flake.homeConfigurations = configs;
  };
}
