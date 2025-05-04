{
  inputs,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    packages = let
      aarch64Pkgs = pkgs.pkgsCross.aarch64-multiplatform;

      buildImage = pkgs.callPackage ./build-image {};
      aarch64Image = pkgs.callPackage ./aarch-image.nix {image = self.nixosConfigurations.nas.config.system.build.sdImage;};
      rockchip = uboot:
        pkgs.callPackage ./rockchip.nix {
          inherit uboot;
          inherit aarch64Image buildImage;
        };
    in {
      inherit aarch64Image;

      "installer/nas" = rockchip aarch64Pkgs.ubootCM3588NAS;
    };
  };
}
