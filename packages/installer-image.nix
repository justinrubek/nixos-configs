{inputs, ...}: {
  perSystem = {
    config,
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
    graphical = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma5.nix"
        extraPackages
      ];
    };
    minimal = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        extraPackages
      ];
    };
  in rec {
    packages = {
      "installer/graphical" = graphical.config.system.build.isoImage;
      "installer/minimal" = minimal.config.system.build.isoImage;
    };
  };
}
