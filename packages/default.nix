{
  imports = [
    ./installer-image.nix
  ];

  perSystem = {
    config,
    pkgs,
    system,
    inputs',
    self',
    ...
  }: {
    packages = {
      inherit (inputs'.neovim-config.packages) neovim;
      material-symbols = pkgs.callPackage ./material-symbols.nix {};
    };
  };
}
