_: {
  config,
  lib,
  ...
}: {
  config = lib.mkMerge [
    {nix.settings.auto-optimise-store = lib.mkDefault true;}
    {
      nix.gc.automatic = lib.mkDefault true;
      nix.gc.options = lib.mkDefault "--delete-older-than 8d";
    }
  ];
}
