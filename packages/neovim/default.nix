{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    system,
    inputs',
    self',
    ...
  }: {
    packages = {
      neovim = inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
        module = import ./config.nix {inherit pkgs inputs';};
      };
    };
  };
}
