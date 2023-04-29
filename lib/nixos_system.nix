input @ {
  self,
  inputs,
  config,
  ...
}: {
  # The input to the custom nixosSystem function
  modules,
  name,
  system,
  ...
}: let
  ###
  ### Configure a nixosSystem call with default values
  ### including this flake's custom modules, modules specified,
  ### a hostname, and other options.
  finalModules =
    [
      {
        boot.tmp.cleanOnBoot = true;
        networking = {
          hostName = name;
          hostId = builtins.substring 0 8 (builtins.hashString "md5" name);
        };
        system.configurationRevision = self.rev or "dirty";
        documentation.man = {
          enable = true;
          generateCaches = true;
        };

        caches.enable = true;
        nix.flakes.enable = true;
      }
    ]
    ++ modules
    ++ [
      inputs.hyprland.nixosModules.default
      inputs.sops-nix.nixosModules.sops
    ]
    # include this flake's modules
    ++ builtins.attrValues self.nixosModules
    ++ builtins.attrValues self.modules;
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = finalModules;
    specialArgs = {
      flakeRootPath = ../.;
    };
  }
