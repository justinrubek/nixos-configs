{
  inputs,
  self,
  ...
}: {
  perSystem = {
    config,
    inputs',
    lib,
    pkgs,
    system,
    self',
    ...
  }: let
    extraPackages = {
      environment.systemPackages = [
        self'.packages.neovim
      ];
    };
    name = "nixos-installer";
    common = [
      {
        i18n = {
          defaultLocale = "en_US.UTF-8";
          extraLocaleSettings = {
            LC_TIME = "en_GB.UTF-8";
          };
        };
        networking = {
          hostName = name;
          hostId = builtins.substring 0 8 (builtins.hashString "md5" name);
        };
        nix.settings = {
          trusted-users = ["@wheel"];
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };
        system.configurationRevision = self.rev or "dirty";
        users.users.nixos.initialHashedPassword = lib.mkForce "$y$j9T$hEdGkuB74JufADwQAM/e0/$dEyelup23BSJ382lO/9LEC2SqnONn082g/R5qG2WV1.";
      }
    ];
    graphical = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma5.nix"
          extraPackages
        ]
        ++ common;
    };
    minimal = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          extraPackages
        ]
        ++ common;
    };
  in rec {
    packages = {
      "installer/graphical" = graphical.config.system.build.isoImage;
      "installer/minimal" = minimal.config.system.build.isoImage;
      "installer/cm3588" = inputs'.nixos-aarch64-images.packages.cm3588NAS;
    };
  };
}
