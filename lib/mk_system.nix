{
  self,
  nixvim,
  ...
} @ inputs: name: nixpkgs:
  nixpkgs.lib.nixosSystem (
    let
      inherit (builtins) attrValues;

      configuration = "${self}/nixos/configurations/${name}";
      entryPoint = import "${configuration}" inputs;
      bootloader = "${configuration}/bootloader.nix";
      hardware = "${configuration}/hardware.nix";
    in {
      system = "x86_64-linux";

      modules =
        [
          {
            boot.cleanTmpDir = true;
            networking.hostName = name;
            system.configurationRevision = self.rev or "dirty";
            documentation.man = {
              enable = true;
              generateCaches = true;
            };

            caches.enable = true;
            nix.flakes.enable = true;
          }
          entryPoint
          bootloader
          hardware
        ]
        ++ attrValues self.nixosModules
        ++ attrValues self.modules;
    }
  )
