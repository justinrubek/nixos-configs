{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.config-parts.flakeModules.nixos
  ];

  config-parts.nixos = {
    modules.shared =
      [
        {
          boot.tmp.cleanOnBoot = true;
          caches.enable = true;
          documentation.man = {
            enable = true;
            generateCaches = true;
          };
          i18n = {
            defaultLocale = "en_US.UTF-8";
            extraLocaleSettings = {
              LC_TIME = "en_GB.UTF-8";
            };
          };
          nix.settings.trusted-users = ["@wheel"];
        }
        inputs.hyprland.nixosModules.default
        inputs.sops-nix.nixosModules.sops
      ]
      ++ builtins.attrValues self.nixosModules;

    configurations = {
      edge.system = "x86_64-linux";
      eunomia.system = "x86_64-linux";
      surface.system = "x86_64-linux";
      rpi5.system = "aarch64-linux";
      media-center.system = "x86_64-linux";
      nas.system = "x86_64-linux";
    };
  };
}
