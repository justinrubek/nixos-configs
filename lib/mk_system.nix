{self, ...} @ inputs: name: nixpkgs:
  nixpkgs.lib.nixosSystem (
    let
      configuration = "${self}/nixos/configurations/${name}";
      entryPoint = import "${configuration}" inputs;
      bootloader = "${configuration}/bootloader.nix";
      hardware = "${configuration}/hardware.nix";
    in {
      system = "x86_64-linux";

      modules = [
        {
          boot.cleanTmpDir = true;
          networking.hostName = name;
          # system.configurationRevsion = self.rev or "dirty";
          documentation.man = {
            enable = true;
            generateCaches = true;
          };
        }
        entryPoint
        bootloader
        hardware
      ];
    }
  )
